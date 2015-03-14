require 'csv'
require 'zip'

class BestchangeRates

  INFO_FILE = 'http://www.bestchange.ru/bm/info.zip'

  # Load zip file, unzip and save files content in memory
  def load_contents
    @contents = []
    temp_file = open(INFO_FILE)
    ::Zip::File.open(temp_file.path) do |zip_file|
      zip_file.glob('*.dat').each do |entry|
        filename = Dir::Tmpname.make_tmpname "/tmp/#{entry.name}", nil
        entry.extract(filename)
        @contents << {
            name: entry.name,
            content: File.open(filename, encoding: 'windows-1251').read
        }
        File.unlink filename
      end
    end
    temp_file.close
    temp_file.unlink
    @contents
  end

  def parse_csv_contents
    @csv_data = {}
    %w{rates cy exch bcodes brates}.each do |key|
      csv = contents.detect{|entry| entry[:name] == "bm_#{key}.dat"}[:content]
      @csv_data[key.to_sym] = CSV.parse csv, col_sep: ';'
    end
    @csv_data
  end

  def contents
    @contents || load_contents
  end

  def info
    csv_info = contents.detect{|x| x[:name] == 'bm_info.dat'}[:content]
    array_info = CSV.parse csv_info, col_sep: '='
    Hash[array_info]
  end

  def csv_data
    @csv_data || parse_csv_contents
  end

  def rates(direction)
    from = currency_id_by_name direction.keys.first
    to = currency_id_by_name direction.values.first
    rates_by_currency_ids(from, to)
  end

  def rates_by_currency_ids(from, to)
    rates_list = csv_data[:rates].select{|entry| entry[0].to_i == from && entry[1].to_i == to }.map do |entry|
      {
          from: currencies[entry[0].to_i],
          to: currencies[entry[1].to_i],
          exchanger: exchangers[entry[2].to_i],
          give: entry[3].to_f,
          get: entry[4].to_f
      }
    end.sort_by{|entry| entry[:give]/entry[:get]}

    rates_list.map.with_index{|rate, i| rate[:position] = i + 1; rate }
  end

  def exchangers
    csv_data[:exch].inject({}){|hash, row| hash[row[0].to_i] = row[1]; hash}
  end

  def currencies
    csv_data[:cy].inject({}){|hash, row| hash[row[0].to_i] = row[2]; hash}
  end

  private

  def currency_id_by_name(name)
    csv_data[:cy].detect{|entry| entry[2] == name || entry[3] == name }[0].to_i
  end

end