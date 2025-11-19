class Day9
  def self.part1(input)
    fs = Day9::BlockFileSystem.new(diskmap: input)
    fs.compact!
    fs.checksum
  end

  def self.part2(input)
    fs = Day9::WholeFileSystem.new(diskmap: input)
    fs.compact!
    fs.checksum
  end

  class FileSystem
    FREESPACE = '.'

    def initialize(string_input = nil, diskmap: nil)
      units = string_input ? self.class.parse_from_string(string_input) : self.class.parse_diskmap(diskmap)
      update_units(units)
    end

    def all_free_space_contiguous?
      first_free_space = blocks.index(FREESPACE)
      last_file_space = blocks.rindex{ |e| e != FREESPACE }
      !first_free_space or first_free_space > last_file_space
    end

    def checksum
      blocks.map.with_index do |filenumber, index|
        (filenumber == FREESPACE) ? 0 : filenumber * index
      end.sum
    end

    def to_s
      blocks.join()
    end

    private

    # Blocks and units will not always be the same concept in child classes.
    # Some child classes are expected to have units that are multiple blocks long,
    # and thus will have to implement something different for this..
    def blocks
      @units
    end

    def update_units(units)
      @units = units
    end

    def self.parse_diskmap(diskmap)
      instructions = diskmap.split(//).map(&:to_i)
      file_number = -1
      blocks = []

      instructions.each_slice(2) do |slice|
        file_length, freespace_length = slice
        file_number += 1
        file_length.times{ blocks << file_number }
        freespace_length.times{ blocks << FREESPACE } if freespace_length
      end
      blocks
    end

    def self.parse_from_string(string_input)
      string_input.split(//).map{ |char| char.ord.between?('0'.ord, '9'.ord) ? char.to_i : char  }
    end
  end

  class WholeFileSystem < FileSystem
    def compact!(limit: nil)
      @blocks = nil # Reset @blocks so that #blocks will recalculate it on next call
      files_to_compact = @units.reject{|u| u.is_freespace?}.sort{|a, b| a.filename <=> b.filename }.reverse

      compaction_count = 0
      files_to_compact.each do |file|
        compact_file!(file)
        compaction_count += 1
        return if limit and compaction_count >= limit
      end
    end

    private

    def blocks
      @blocks ||= @units.map{ |unit| Array.new(unit.length){ |i| unit.symbol } }.flatten
    end

    def compact_file!(file)
      location_of_file = @units.index(file)
      free_space_needed = file.length
      location_of_freespace = @units[0...location_of_file].index{ |unit| unit.is_freespace? and unit.length >= free_space_needed }
      if location_of_freespace
        freespace = @units[location_of_freespace]
        @units[location_of_freespace] = file
        # Adjust the freespace
        if file.length == freespace.length
          @units[location_of_file] = freespace
        else
          @units[location_of_file] = Unit.new(FileSystem::FREESPACE, file.length)
          @units.insert(location_of_freespace + 1, Unit.new(FileSystem::FREESPACE, freespace.length - file.length))
        end
      end
    end

    def update_units(blocks)
      @blocks = nil # Reset @blocks so that #blocks will recalculate it on next call
      @units = [] # symbol, length

      create_unit_from = ->(char) do
        length = blocks.index{ |e| e != char } || blocks.length
        blocks.slice!(0...length)
        Unit.new(char, length)
      end

      until blocks.empty?
        @units << create_unit_from.call(blocks[0])
      end
    end

    class Unit
      attr_reader :symbol, :length
      def initialize(symbol, length)
        @symbol = symbol
        @length = length
      end

      def filename
        @symbol unless is_freespace?
      end

      def inspect
        "#<Unit '#{symbol}' x#{length}>"
      end

      def is_freespace?
        @symbol == FileSystem::FREESPACE
      end
    end
  end

  class BlockFileSystem < FileSystem
    alias_method :update_blocks, :update_units

    def compact!(limit: nil)
      compaction_count = 0
      compacted = []
      free_space_to_add = 0
      remaining = blocks
      until remaining.empty? or (limit and compaction_count >= limit)
        # Confirm that there are filled blocks remaining
        final_occupied_block = remaining.rindex{|e| e != FREESPACE}
        break unless final_occupied_block

        # Pop all of the already free space off the end of the list, saving the count for later
        first_of_freespace_at_end = final_occupied_block + 1
        free_space_to_add += remaining.length - first_of_freespace_at_end
        remaining.slice!(first_of_freespace_at_end..-1)

        # Stop if there is no work remaining
        break if remaining.empty?

        # Pull all of the filled space off the front of the list and tuck it into `compacted`
        first_of_freespace_at_beginning = remaining.index(FREESPACE)
        blocks_at_beginning = remaining.slice!(0...first_of_freespace_at_beginning)
        compacted.push(*blocks_at_beginning)

        # Stop if there is no work remaining
        break if remaining.empty?

        # Take the final filled block and move it into the current free space
        # (We do this by adding it to compacted and then removing the first item from the working list)
        remaining.delete_at(0)
        compacted.push remaining.delete_at(-1)
        free_space_to_add += 1

        # Increment loop counter
        compaction_count += 1
      end
      # Update @units to contain the compacted blocks along with anything remaining
      # in the working list and all the free space
      update_blocks(compacted + remaining + Array.new(free_space_to_add){ |i| FREESPACE })
    end
  end
end
