class PlatesController < ApplicationController
  include Submission::Creation

  def new
  end

  def create
    submission = create_submission(params)

    if submission
      LocalSubmission.find_or_create_by_uuid(submission.uuid)
      submission.update_attributes!(:assets => Warehouse::Plate.well_uuids_from_plate_barcodes(params[:submission][:plate_barcodes]))
    end

    respond_to do |format|
      if submission.submit!
        format.html { redirect_to(submission_path(submission.uuid)) }
      else
        flash[:error] = 'Failed to create submission'
        format.html { redirect_to(submissions_path) }
      end
    end
  end

end
