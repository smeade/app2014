class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy, :restart]
  before_action :set_entries, only: [:index, :create, :restart]

  # GET /entries
  # GET /entries.json
  def index
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params, date: Date.today())

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.js   { 
          @created_entry = @entry
          @entry = Entry.new unless @entry.running
        }
        format.json { render action: 'show', status: :created, location: @entry }
      else
        format.html { render action: 'new' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def restart
    @entry_running = Entry.running.first
    @entry_running.stop if @entry_running
    
    @entry.start

    render :index
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    # When updating due to timer being stopped, calculate elapsed time
    if params[:commit] == 'Stop'
      @entry.minutes = (@entry.minutes || 0 ) + (Time.now() - @entry.updated_at).to_i / 60
      @entry.running = false
    end

    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.js   { 
          @updated_entry = @entry
          @entry = Entry.new unless @entry.running
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    def set_entries
      @entries_today = Entry.complete.today
      @entries_yesterday = Entry.complete.yesterday
      @entries_with_journal_text = Entry.with_journal_text      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:id, :date, :minutes, :project_id, :description, :journal, :billable, :project_id_or_name)
    end
end
