class FacilitiesController < ApplicationController
  before_action :set_facility, only: %i[ show edit update destroy ]
#  before_action :ensure_frame_response, only: %i[ new edit show ]

  def index
    @facilities = Facility.all
  end

  def show
  end

  def new
    @facility = Facility.new
  end

  def edit
  end

  def create
    @facility = Facility.new(facility_params)

    respond_to do |format|
      if @facility.save
# TODO six 1
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("facilities", 
            partial: "facility", 
            locals: { facility: @facility },
            class: 'fade-in-div'
          )
        end
        format.html { redirect_to facility_url(@facility), notice: "Facility was successfully created." }
        format.json { render :show, status: :created, location: @facility }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @facility.update(facility_params)
# TODO six 2
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace( @facility,
            partial: "facility", 
            locals: { facility: @facility },
            class: 'fade-in-div'
          )
        end
        format.html { redirect_to facility_url(@facility), notice: "Facility was successfully updated." }
        format.json { render :show, status: :ok, location: @facility }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facilities/1 or /facilities/1.json
  def destroy
    @facility.destroy

    respond_to do |format|
# TODO seven 1
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace( @facility,
          partial: "remove_div", 
          locals: { facility: @facility },
          class: 'fade-in-div'
        )
      end
      format.html { redirect_to facilities_url, notice: "Facility was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def ensure_frame_response
      redirect_to root_path unless turbo_frame_request?
    end

    def set_facility
      @facility = Facility.find(params[:id])
    end

    def facility_params
      params.require(:facility).permit(:name, :description, :capacity)
    end
end
