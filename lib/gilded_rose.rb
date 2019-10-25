class GildedRose
  def initialize(items)
    @items = items
    @staggered_behaviour_items = ['Backstage passes to a TAFKAL80ETC concert']
    @always_increase_items = ['Aged Brie']
    @accelerated_decay_items = ['Conjured Mana Cake']
    @legendary_items = ['Sulfuras, Hand of Ragnaros']
  end

  def update_quality
    @items.each do |item|
      case route(item.name)
      when 'staggered'
        item.quality = update_staggered(item: item)
      when 'always_increase'
        item.quality = update_general(item: item, change_pos_sell_in: 1, change_neg_sell_in: 2)
      when 'accelerated_decay'
        item.quality = update_general(item: item, change_pos_sell_in: -2, change_neg_sell_in: -4)
      when 'legendary'
        item.quality = 80
      else
        item.quality = update_general(item: item, change_pos_sell_in: -1, change_neg_sell_in: -2)
      end
      item.sell_in -= 1 unless route(item.name) == 'legendary'
    end
  end

  private

  def update_staggered(item:)
    case item.sell_in
    when 6..10
      item.quality = [[item.quality + 2, 0].max, 50].min
    when 1..5
      item.quality = [[item.quality + 3, 0].max, 50].min
    when -Float::INFINITY..0
      item.quality = 0
    else
      item.quality = [[item.quality + 1, 0].max, 50].min
    end
  end

  def update_general(item:, change_pos_sell_in:, change_neg_sell_in:)
    case item.sell_in
    when 1..Float::INFINITY
      [[item.quality + change_pos_sell_in, 0].max, 50].min
    when -Float::INFINITY..0
      [[item.quality + change_neg_sell_in, 0].max, 50].min
    end
  end

  def route(item_name)
    return 'staggered' if @staggered_behaviour_items.include?(item_name)
    return 'always_increase' if @always_increase_items.include?(item_name)
    return 'accelerated_decay' if @accelerated_decay_items.include?(item_name)
    return 'legendary' if @legendary_items.include?(item_name)
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
