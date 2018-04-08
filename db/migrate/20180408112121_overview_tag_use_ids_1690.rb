class OverviewTagUseIds1690 < ActiveRecord::Migration[5.1]
  def up
    Overview.all.each { |o| up_single(o) }
  end

  private

  def up_single(overview)
    return unless checks_tags?(overview)

    new_values = Tag::Item.where(name: old_values(overview)).map(&:id)
    set_new_values(overview, new_values)

    overview.save
  end

  def checks_tags?(overview)
    overview.condition.key? 'ticket.tags'
  end

  def set_new_values(overview, new_values)
    overview.condition['ticket.tags']['value'] = new_values.join(',')
  end

  def old_values(overview)
    overview.condition['ticket.tags']['value']
            .split(',')
            .map(&:strip)
  end
end
