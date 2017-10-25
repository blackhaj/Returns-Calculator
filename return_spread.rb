require 'CSV'
require 'terminal-table'

class RollingReturnCalc

    def initialize(file_name)
        @raw_data = CSV.read(file_name)
        @raw_prices = data_strip(@raw_data)
        puts data_presenter(@raw_prices)
    end


    private

    def data_presenter(array)
        results = [["Time-Period","Low", "High", "Average"]]
        results << calc_array(@raw_prices, 4, "One Month")
        results << calc_array(@raw_prices, 13, "Three Months")
        results << calc_array(@raw_prices, 26, "Six Months")
        results << calc_array(@raw_prices, 52, "One Year")
        results << calc_array(@raw_prices, 156, "Three Years")
        results << calc_array(@raw_prices, 260, "Five Years")
        results << calc_array(@raw_prices, 520, "Ten Years")
        results << calc_array(@raw_prices, 1040, "Twenty Years")
        results << calc_array(@raw_prices, 1560, "Thirty Years")
        table = Terminal::Table.new :rows => results
        table
    end

    def calc_array(array, no_weeks, title)
        returns = generate_rolling_returns(array,no_weeks)
        [title, lowest(returns).round(2).to_s + "%",highest(returns).round(2).to_s + "%", average(returns).round(2).to_s + "%"]
    end

    def data_strip(csv)
        csv.map {|line| line[1].to_f}
    end

    def generate_rolling_returns(array, no_weeks) #assumes data comes in in weeks!!!
        returns_array = array.map.with_index do |x,i|
            unless array[i+no_weeks-1] == nil
                (array[i+no_weeks-1].to_f-x.to_f)/x.to_f #remove to_f's in final
            end
        end
        returns_array = returns_array.compact
    end

    def lowest(array)
        array.min.to_f * 100
    end

    def highest(array)
        array.max.to_f * 100
    end

    def average(array)
        array.inject(:+)/array.length.to_f * 100
    end


end

check_data = RollingReturnCalc.new("new_data.csv")

