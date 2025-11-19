class Day9
  def self.part1(input)
    fs = Day9::BlockFileSystem.new(diskmap: input)
    fs.compact!
    fs.checksum
  end

  def self.part2(input)
    "TBD"
  end

  class FileSystem
    FREESPACE = '.'

    def initialize(string_input = nil, diskmap: nil)
      units = string_input ? self.class.parse_from_string(string_input) : self.class.parse_diskmap(diskmap)
      set_units(units)
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

    def set_units(units)
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

  class BlockFileSystem < FileSystem
    def compact!(limit: nil)
      compaction_count = 0
      compacted = []
      free_space_to_add = 0
      remaining = @units
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
      set_units(compacted + remaining + Array.new(free_space_to_add){ |i| FREESPACE })
    end
  end
end
