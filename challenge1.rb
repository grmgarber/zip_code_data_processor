require 'json'

class Challenge1

  DEFAULT_SRC_FILE_SPEC = 'zips.json'.freeze
  LARGE_STATE_MIN_POPULATION = 10_000_000
  STATE = 'state'
  CITY = 'city'
  POP = 'pop'

  # Features:
  #     Return States with Populations above 10 Million
  #     Return Average City Population by State
  #     Return Largest and Smallest Cities by State

  # Sample element of the array of US zip code information
  # {
  #     "_id": "10280",
  #     "city": "NEW YORK",
  #     "state": "NY",
  #     "pop": 5574,
  #     "loc": [
  #         -74.016323,
  #         40.710537
  #     ]
  # }
  #
  #
    attr_accessor :source  # ruby array containing information for individual zip codes (see a sample element above)

    # Invoke the code on the following line to produce all results
    #       Challenge1.perform
    def self.perform(src_file_spec = DEFAULT_SRC_FILE_SPEC)
      self.new.perform(src_file_spec)
    end

    def perform(src_file_spec)
      begin
        acquire_source(src_file_spec)   # Read the source file and extract the array of zip code data
      rescue =>exc
        raise "Unable to acquire source data from #{src_file_spec}: #{exc.message}"
      end  unless source

      process_statistics(collect_state_statistics(source)) # process the source file and compute all results
    end

    private

    # Returns intermediate statistics for each state, which will be further processed to yield 3 required answers
    def collect_state_statistics(source)

      # All the required output is on the level of states, so collect the necessary info into a hash keyed by state.
      # Observation: the source array is already sorted by states, but not cities within states

      source.each_with_object(Hash.new) do |sr, memo|
        curr_state = sr[STATE]; curr_city = sr[CITY]; curr_pop = sr[POP]
        state_info = memo[curr_state]
        unless state_info
          state_info = new_state_info_for(curr_state)
          memo[curr_state] = state_info
        end
        state_info.pop += curr_pop
        city_pop = (state_info.cities[curr_city] || 0) + curr_pop
        state_info.cities[curr_city] = city_pop
      end
    end

    def process_statistics(statistics)
      sorted_state_infos = statistics.values.sort { |a, b| a.state <=> b.state }

      OpenStruct.new(
        feature1: feature_1(sorted_state_infos),
        feature2: feature_2(sorted_state_infos),
        feature3: feature_3(sorted_state_infos)
      )
    end

    def acquire_source(file_spec)
      self.source = File.open(file_spec) { |f| JSON.parse(f.read)['cities'] }
    end

    # Returns states with large populations
    def feature_1(state_infos)
      state_infos.select { |state_info| state_info.pop > LARGE_STATE_MIN_POPULATION }.
        map { |state_info| { _id: state_info.state, pop: state_info.pop } }
    end

    # Returns average city population per state
    def feature_2(state_infos)
      state_infos.map do |state_info|
        { _id: state_info.state, avgCityPop: state_info.pop / state_info.cities.size }
      end
    end

    # Biggest and smallest cities in each state
    def feature_3(state_infos)
      state_infos.map do |state_info|
        cities = state_info.cities.to_a  # array of two element arrays like e.g. ['Fair Lawn', 32000]
        max_city = cities.max_by(&:last)  # highest pop city
        min_city = cities.min_by(&:last)  # lowest pop city
        { _id: state_info.state,
          biggestCity:  { name: max_city.first, pop: max_city.last },
          smallestCity: { name: min_city.first, pop: min_city.last }
        }
      end
    end

    # Intermediate statistics for individual states will be collected in open_struct's returned by this method
    def new_state_info_for(state)
      # state_info structure will contain :name, :pop,
      #    and :cities being a hash keyed by city name, with the values being city population
      OpenStruct.new(state: state, pop: 0, cities: Hash.new)
    end
  end
