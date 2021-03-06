class KanbanPane::FinishedPane < KanbanPane
  def get_issues(options={})
    return [[]] if missing_settings('finished')

    status_id = settings['panes']['finished']['status']
    days = settings['panes']['finished']['limit'] || 7

    conditions = ARCondition.new
    conditions.add ["#{Issue.table_name}.status_id = ?", status_id]
    conditions.add ["#{Issue.table_name}.updated_on > ?", days.to_f.days.ago]
      
    issues = Issue.visible.all(:include => :assigned_to,
                               :order => "#{Issue.table_name}.updated_on DESC",
                               :conditions => conditions.conditions)

    return issues.group_by(&:assigned_to)
  end
  
end

