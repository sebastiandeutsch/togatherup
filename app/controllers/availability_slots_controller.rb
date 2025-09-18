class AvailabilitySlotsController < ApplicationController
  before_action :require_login
  before_action :set_availability_slot, only: %i[edit update destroy]

  def index
    @availability_slots = current_user.availability_slots.ordered
    @availability_slot = current_user.availability_slots.new
  end

  def new
    @availability_slot = current_user.availability_slots.new
  end

  def create
    @availability_slot = current_user.availability_slots.new(availability_slot_params)

    if @availability_slot.save
      redirect_to availability_slots_path, notice: "Availability saved"
    else
      @availability_slots = current_user.availability_slots.ordered
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @availability_slot.update(availability_slot_params)
      redirect_to availability_slots_path, notice: "Availability updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @availability_slot.destroy
    redirect_to availability_slots_path, notice: "Availability removed"
  end

  private

  def set_availability_slot
    @availability_slot = current_user.availability_slots.find(params[:id])
  end

  def availability_slot_params
    params.require(:availability_slot).permit(:day_of_week, :starts_at, :ends_at)
  end
end
