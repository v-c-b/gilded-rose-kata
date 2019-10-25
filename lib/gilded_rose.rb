class GildedRose

  def initialize(items)
    @items = items
    @special_items = [
      'Backstage passes to a TAFKAL80ETC concert',
      'Aged Brie',
      'Sulfuras, Hand of Ragnaros'
    ]
  end

  def update_quality()
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
      if item.name == 'Aged Brie'
        case item.sell_in
        when 1..Float::INFINITY
          item.quality = increase_by_but_not_over(item.quality, 1, 50)
        when -Float::INFINITY..0
          item.quality = increase_by_but_not_over(item.quality, 2, 50)
        end
      end
      if ! @special_items.include?(item.name)
        case item.sell_in
        when 1..Float::INFINITY
          item.quality = decrease_by_but_not_below(item.quality, 1, 0)
        when -Float::INFINITY..0
          item.quality = decrease_by_but_not_below(item.quality, 2, 0)
        end
      end
      item.sell_in -= 1 if item.name != 'Sulfuras, Hand of Ragnaros'
    end
  end

private
  def increase_by_but_not_over(item, increment, limit)
    [item+increment, limit].min
  end

  def decrease_by_but_not_below(item, decrement, limit)
    [item-decrement, limit].max
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
