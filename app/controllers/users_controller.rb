class UsersController < ApplicationController
  before_action :set_user, only: [:buy_pack, :show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @users = User.order('users.training_sessions ASC').all
    @authuri = GoogleSlides.new.auth_uri
  end
  def show
  end

  def new
    @user = User.new
  end
  def edit
  end
  
  def buy_pack
    if request.patch?
      user = User.find(params[:id])
      user.increment!(:training_sessions, by = params[:size].to_i)
      notif = "#{user.name} bought #{params[:size]} sessions for a new total of #{user.training_sessions} sessions."
      logger.info notif
      user.microposts << Micropost.new(content:notif, user_id: user.id)
      redirect_to user_path(user.id), notice: notif
    else # GET
      package = Package.order('packages.sessions ASC').all
      @packages = package
    end
  end

  def use_makeup
    # Use make up session and set date used
    user = User.find(params[:id])
    user.increment!(:training_sessions, by = 1)
    user.update(makeup: Date.today)
    notif = "#{user.name} used make-up session for a new total of #{user.training_sessions} sessions."
    logger.info notif
    user.microposts << Micropost.new(content: notif, user_id: user.id)
    redirect_to user_path(user.id), notice: notif
  end


  def get_sessions
    user = User.find_by(name: params[:name])
    user.training_sessions
  end

  # POST /users
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        # TODO: Add welcome email once roll out to users.
        # UserMailer.with(user: @user).welcome_email.deliver!
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed!' }
      format.json { head :no_content }
    end
  end

  def workout
    # Get last token or refresh
    t = Token.last
    # If no token or refresh, re-establish Google auth
    unless t and t.refresh_token
      redirect_to GoogleSlides.new.auth_uri
      return
    end
    # Set up the drive and slides service
    @drive = GoogleSlides.drive_setup(t.fresh_token) 
    @slides = GoogleSlides.slides_setup(t.fresh_token) 
    folder_id = nil
    # Get folder of the user requested
    folder = @drive.list_files(q: "'#{ENV["PROGRAM_FOLDER"]}' in parents and name='#{@user.name}'", fields: "files(id)")
    # If user dir doesn't exist, create it
    if folder.files.empty?
      new_folder = Google::Apis::DriveV3::File.new
      new_folder.name = @user.name
      new_folder.parents = [ENV["PROGRAM_FOLDER"]]
      new_folder.mime_type = 'application/vnd.google-apps.folder'
      file = @drive.create_file(file_object=new_folder)
    end
    @workouts = []
    unless folder.files.empty?
      folder_id = folder.files[0].id.to_s
      work = Hash.new
      # Get past workouts
      files = @drive.list_files(q: "'#{folder_id}' in parents and not trashed", 
                                order_by: "createdTime desc", 
                                fields: "files(name, id, parents, web_view_link)")
      # Only display the last 4 sessions
      files.files[0..3].each do |file|
        work[file.id] = Hash.new
        work[file.id]["link"] = file.web_view_link
        # Get page elements from presentation
        elements = @slides.get_presentation(file.id).slides[0].page_elements
        elements.each do |ele|
          # Each element on the slide - check if its a text region
          if ele.shape.text
            work[file.id][ele.title] = []
            ele.shape.text.text_elements.each do |txt|
              # Fill workouts with content from slide
              if txt.text_run and txt.text_run.content and txt.text_run.content != "\n"
                work[file.id][ele.title] << txt.text_run.content
              end
            end
          end
        end
        @workouts << work[file.id]
      end
    end

    if request.post?
      field_count = 0
      type = []
      content = []

      # Accepts blank or filled params to format new slide correctly
      # Offset the params in case starting one is empty
      for i in 1..4 do 
        unless params["content#{i}"].blank? and params["type#{i}"].blank?
          content.push(params["content#{i}"])
          type.push(params["type#{i}"])
          field_count += 1
        end
      end
      
      # Select template based on number of fields
      if field_count < 3
        template_file = @drive.list_files(
          q: "'#{ENV["PROGRAM_FOLDER"]}' in parents and name='Template2'").files[0]
      elsif field_count == 3
        template_file = @drive.list_files(
          q: "'#{ENV["PROGRAM_FOLDER"]}' in parents and name='Template3'").files[0]
      else
        template_file = @drive.list_files(
          q: "'#{ENV["PROGRAM_FOLDER"]}' in parents and name='Template'").files[0]
      end

      # Copy template to new file
      new_title = Time.now.in_time_zone('EST').strftime("%b %d %Y")
      new_file = Google::Apis::DriveV3::File.new
      new_file.name = new_title
      new_file.parents = [folder_id]
      new_tmp_slide = @drive.copy_file(file_id=template_file.id, file_object = new_file)

      # Get presentation of the newly created file
      new_presentation = @slides.get_presentation(new_tmp_slide.id)

      # Replace place holders in template with content from params
      requests = [replace_in_slide(
        place_holder='{{DATE}}',
        value=Time.now.in_time_zone('EST').strftime("%b %d %Y").upcase!)]

      # Add extra new lines for proper formatting
      for i in 1..4 do
        if content[i-1] and content[i-1].lines.count == 5
          type[i-1] << "\n"
          content[i-1] << "\n"  
        end
        while content[i-1] and content[i-1].count("\n") < 4
          content[i-1] << "\n" 
        end 
        requests << replace_in_slide(place_holder="{{BLOCK_#{i}}}",value=type[i-1])
        requests << replace_in_slide(place_holder="{{CONTENT_#{i}}}",value=content[i-1]) 
      end
      requests << replace_in_slide(place_holder="{{QUOTE}}",value=params["quote"])

      # Execute the request
      req = Google::Apis::SlidesV1::BatchUpdatePresentationRequest.new(requests: requests)
      response = @slides.batch_update_presentation(
        new_presentation.presentation_id,
        req
      )
      # Reload workout page including newly created workout
      redirect_to workout_user_path
    else
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :notes, :phone, :address, :makeup, :medical, :training_sessions)
    end

    def token_expired?
      Time.at(session[:credentials].expires_at.to_i) < Time.now
    end

end


def replace_in_slide(place_holder,value)
        # Insert text into the box, using the supplied element ID.
        { 
          replace_all_text: {
            contains_text: {
              match_case: false,
              text: place_holder
            },
            replace_text: value
          }
        }

end
