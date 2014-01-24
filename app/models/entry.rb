class Entry < ActiveRecord::Base

  belongs_to :project

  # Public: sets project based on either a project_id or project name
  #
  # project_id_or_name - The String value of either an id or name of a project
  # 
  # Examples
  #
  #   project.project_id_or_name=("New project")
  #   project.project_id_or_name=("123")
  #
  # Returns the project
  def project_id_or_name=(project_id_or_name)
    if project_id_or_name.to_i == 0
      self.project_id = Project.find_or_create_by(name: project_id_or_name).id
    else
      self.project_id = Project.find_or_create_by(project_id_or_name).id
    end
  end

  def project_id_or_name
    self.id
  end

end
