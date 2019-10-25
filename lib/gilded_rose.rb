class GildedRose
  def initialize(items)
    @items = items
    @special_items = [
      'Backstage passes to a TAFKAL80ETC concert',
      'Aged Brie',
      'Sulfuras, Hand of Ragnaros',
      'Conjured'
    ]
  end

  def update_quality
    @items.each do |item|
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        case item.sell_in
        when 6..10
          item.quality = increase_by_but_not_over(item.quality, 2, 50)
        when 1..5
          item.quality = increase_by_but_not_over(item.quality, 3, 50)
        when -Float::INFINITY..0
          item.quality = 0
        else
          item.quality = increase_by_but_not_over(item.quality, 1, 50)
        end
      end
      if item.name.include?('Conjured')
        item.quality = update_general_type(item: item, change_pos_sell_in: -2, change_neg_sell_in: -4 )
      end
      if item.name == 'Aged Brie'
        item.quality = update_general_type(item: item, change_pos_sell_in: 1, change_neg_sell_in: 2 )
      end
      unless @special_items.include?(item.name) or item.name.include?('Conjured')
        item.quality = update_general_type(item: item, change_pos_sell_in: -1, change_neg_sell_in: -2 )
      end
      item.sell_in -= 1 if item.name != 'Sulfuras, Hand of Ragnaros'
    end
  end

  private

  def update_general_type(item:, change_pos_sell_in:, change_neg_sell_in:)
    case item.sell_in
    when 1..Float::INFINITY
      [[item.quality + change_pos_sell_in, 0].max, 50].min
    when -Float::INFINITY..0
      [[item.quality + change_neg_sell_in, 0].max, 50].min
    end
  end

  def increase_by_but_not_over(item, increment, limit)
    [item + increment, limit].min
  end

  def decrease_by_but_not_below(item, decrement, limit)
    [item - decrement, limit].max
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
