########### Angkan Baidya ###########
########### abaidya ###########
########### 112309655 ###########

require 'fileutils'


def insert(dir, filename)
    testing = filename.match(/(^snap)\d{3,}.txt$/)


    if testing == nil
        return "invalid filename"
    end

    if Dir.empty?(dir)
        File.new(File.join(dir,filename), 'a+').close
        return "done"
    end

    counter = 0
    Dir.foreach(dir) do |fileName|
        checkingg = fileName.match(/^snap\d{3,}.txt$/)
        if checkingg !=  nil
            counter = counter + 1
        end
    end

    if counter == 0
        File.new(File.join(dir,filename), 'a+').close
        return "done"
    end

    copyoffilename = filename
    numberArray = Array.new
    filename = filename.match(/\d{1,}/)
    filename = filename.to_s
    filename = filename.to_i
    Dir.foreach(dir) do |fileName|
        checker = fileName.match(/^snap\d{3,}.txt$/)
        checker = checker.to_s
        if checker != nil
            numberToAdd = checker.match(/\d{3,}/)
            numberToAdd = numberToAdd.to_s
            numberToAdd = numberToAdd.to_i
            numberArray.push(numberToAdd)
            end
    end
    booleanResult = numberArray.include? filename
    if booleanResult == false
        return "invalid filename"
    end
    maxnumber =  numberArray.max
    newmaxnumber = maxnumber + 1
    newmaxnumber = newmaxnumber.to_s
    result = File.zero?(copyoffilename)

    if result == false
        Dir.foreach(dir) do |x|
            if x == copyoffilename
                parsedNum = x.match(/\d{3,}/)
                parsedNum = parsedNum.to_s
                parsedNum = parsedNum.to_i
                parsedNum = parsedNum + 1
                stringbuild = ""
                if parsedNum < 10
                    effective = parsedNum.to_s
                    stringbuild = "snap" + "00" + effective + ".txt"
                    File.new(File.join(dir,stringbuild), 'a+').close
                end

                if parsedNum > 10
                    effectivetwo = parsedNum.to_s
                    stringbuild = "snap" + effectivetwo + ".txt"
                    File.new(File.join(dir,stringbuild), 'a+').close
                end
                fn = File.join(dir,stringbuild)
                File.delete(fn) # delete one ahead
                fntwo= File.join(dir,copyoffilename)
                fnfour = File.join(dir,stringbuild)
                File.rename(fntwo,fnfour)
                File.new(File.join(dir,copyoffilename), 'a+').close
            end
        end
        end

    if filename < 10
        stringbuild = "snap" + "00" + newmaxnumber + ".txt"
        File.new(File.join(dir,stringbuild), 'a+').close

        return "done"
    end

    if filename > 10
        stringbuild = "snap" + newmaxnumber + ".txt"
        File.new(File.join(dir,stringbuild), 'a+').close

        return "done"
    end




end
FileUtils.rm_rf(Dir.new('tmp-data')) if Dir.exist?('tmp-data')
Dir.mkdir('tmp-data')
File.new(File.join('tmp-data','snap9995.txt'), 'a+').close
File.new(File.join('tmp-data','snap9996.txt'), 'a+').close
File.open(File.join('tmp-data','snap9997.txt'), 'a+') { |file|
    file.write('snap9997')
    file.close
}
File.new(File.join('tmp-data','snap9998.txt'), 'a+').close
File.new(File.join('tmp-data','snap9999.txt'), 'a+').close
insert(Dir.new('tmp-data'), 'snap9997.txt')




