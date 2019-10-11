# tasks can be run in the console: rake task_name

desc 'Sends group users a reminder email about the approaching group date.'
task :group_reminder_email => :environment do
  begin
    two_weeks_from_now = Date.current + 2.weeks
    one_week_from_now = Date.current + 1.week

    one_week_groups = Group.where(santas_assigned: true).where(gift_due_date: one_week_from_now)
    two_weeks_groups = Group.where(santas_assigned: true).where(gift_due_date: two_weeks_from_now)
    if one_week_groups.present?
      one_week_groups.find_each do |group|
        group.users.find_each do |user|
          next if user.email.blank?
          NotifierMailer.with(user: user, group: group).gift_due_date(7).deliver_later
        end
      end
    end
    if two_weeks_groups.present?
      two_weeks_groups.find_each do |group|
        group.users.find_each do |user|
          next if user.email.blank?
          NotifierMailer.with(user: user, group: group).gift_due_date(14).deliver_later
        end
      end
    end
  rescue StandardError => e
    RescueMailer.rake_task_rescue('group_reminder_email', e).deliver_later
  end
end
