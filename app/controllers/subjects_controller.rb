class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.search(params[:q]).order(created_at: :desc)
    @image_subjects = @subjects.where('content_type LIKE ?', '%image%')
    @other_subjects = @subjects.where('content_type NOT LIKE ?', '%image%')
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end
  
  # GET /subjects/1/edit
  def edit
  end
  
  # POST /subjects/upload
  def upload
    @subject = Subject.new
    @subject.attachment = params[:attachment].first
    @subject.copyright_owner = current_user.name if @subject.copyright_owner.blank?
    @subject.copyright_license = 'CC BY-NC-SA 4.0' if @subject.copyright_license.blank?
    if @subject.save 
      render :show, status: :ok, location: @subject
    else
      render :nothing, status: :unprocessable_entity
    end
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(subject_params)
    @subject.copyright_owner = current_user.name if @subject.copyright_owner.blank?
    @subject.copyright_license = 'CC BY-NC-SA 4.0' if @subject.copyright_license.blank?
    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        #format.json { render :show, status: :ok, location: @subject }
        #format.js
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name, :attachment, :attachment_cache, :content_type, :copyright_owner, :copyright_license,  :tag_list => [])
    end
end
