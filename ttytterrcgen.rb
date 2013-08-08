#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#require DateTime

Version = "1.1"

# Start without the ascii art ?
    $start = false
# are previous mentions searched ?
    $mentions = true
# Do auto split messages at 140 chars ?
    $split = true
# worldwide trending ?
    $WorldWide = false
    $searchhits = 32

$line = "#=============================================================================="

#== DATABASE begin =============================================================

$friends = [
    "@xah_lee" ,
    "@lemasney" , "@tech_arts" ,
    "@Frederic_Molas" , "@Seb_du_Grenier" ,
    "@vertpotam" ,
    "@raymondh" , 
    ]

$tracking = [
    '#7dfps', "#Mojam",
    ]

$lists = [
    'xah_lee/comp', 'xah_lee/math',
    ]

$filter = [
    "fb.me", "facebook.com",
    "KohLanta",
    "\#wow",
    "Please RT", "pl[s|z] RT",
    ]

$ui_colors = {
    # available Colors:
    # blue, cyan, green, magenta, off, red, yellow,
    'colourdefault' => 'CYAN',
    'colourdm'      => 'MAGENTA',
    'colourlist'    => 'BLUE',
    'colourme'      => 'GREEN',
    'colourprompt'  => 'CYAN',
    'colourreply'   => 'YELLOW',
    'coloursearch'  => 'OFF',
    'colourwarn'    => 'MAGENTA',
}

$plugins = [
    "",
]

$locations = {
    # "location" => [ 'lat', 'long' , trendid/woeid , [ "timezone", "elevation",] ]
    # http://www.flickr.com/places/info/1
    # France
    "Colomiers" => [ "lat=43.625146", "long=1.331790", 55863628, [ 'UTC?', "180m", ]  ],
    "Capitole" => [ "lat=43.604413", "long=1.443373", 12657325, [ 'UTC?', "151m", ]  ],
    "Toulouse" => [ "lat=43.604413", "long=1.443373", 12597186, [ 'UTC?', "151m", ]  ],

    "Auch" => [ "lat=43.646478", "long=0.586593", 7153323, [ 'UTC?', "165m", ]  ],
    "Souston" => [ "lat=43.754383", "long=-1.329684", 7153309, [ 'UTC?', "8m", ]  ],
    "Cap Breton" => [ "lat=43.649832", "long=-1.433973", 7153309, [ 'UTC?', "5m", ]  ],
    "Dax" => [ "lat=43.711155", "long=-1.051719", 7153309, [ 'UTC?', "25m", ]  ],
    "Leon" => [ "lat=43.875833", "long=-1.302794", 7153309, [ 'UTC?', "20m", ]  ],

    # Thailand
    "NNY" => [ "lat=14.203184", "long=101.217236", 2347168, [ 'UTC?', "11m", ]  ],

    # China. woeid: 23424781
    #       Guyang, Guizhou,
    "Chengdu" => [ "lat=30.571487", "long=104.066167", 12578016, [ 'UTC?', "935m", ] ],
    "Beijing" => [ "lat=39.904086", "long=116.407492", 12578011, [ 'UTC?', "52m", ] ],
    "Shanghai" => [ "lat=31.229454" , "long=121.471230", 12578012, [ 'UTC?', "9m", ] ],

    # Japan
    "Japan" => [ "", "", 23424856, [ "UTC?", "m", ] ],
    # Fukuoka prefecture: 58646425
    "Fukuoka" => ["", "", 1117099, [ "UTC?", "m", ] ],
    "Shiga" => ["", "", 2345884, [ "UTC?", "m", ] ],
    "Tokyo" => ["", "", 1118370, [ "UTC?", "m", ] ],
    "Sakado" => ["", "", 2345889, [ "UTC?", "m", ] ],

    # Europe
    "Brussel" => [ "lat=50.903730", "long=4.489457", 23424757, [ 'UTC?', "35m", ]  ], # Airport, Brussel, Belgique
    "London" => [ "lat=51.500152", "long=-0.126236", 23424975, [ 'UTC?', "12m", ]  ],

    # USA
    "NYUSA" => [ "lat=40.783434", "long=-73.966250", 2347591, [ 'UTC?', "35m", ]  ],

    #"" => ["", "", [ "UTC?", "m", ] ],
    }

#== DATABASE end ===============================================================
#===============================================================================


def main ()
        if $*[0] == "--help" or $*[0] == "-H" then intro
        elsif $*[0] == nil then gen_rc(nil)
            puts "**** ~/.ttytterrc updated ****"
        else gen_rc($*[0])
            puts "**** ~/.ttytterrc updated with the localization of #{$*[0]} ****"
        end
end

def gen_rc (loc)
    " Don't forget to add "" around friends. "
    rc = gen_mainsettings +
        gen_stuff(['exts', "Plugins"], $plugins, ',', []) +
        gen_stuff(['readline', "Friends/readline"], $friends, ',', ['"', '"']) +
        gen_stuff(['filter', "Filters"], $filter, '|', ['(', ')']) +
        gen_stuff(['track', "Tracked Topics"], $tracking, ' ', [])

    if loc == nil then rc += gen_location("NO LOCATION")
    else rc += gen_location(loc) end

    writerc(rc)
end

def writerc (rc)
    home = `echo $HOME`.slice(0..-2)
    f = File.open(File.join(home, ".ttytterrc"), 'w')
    f.write(rc)
    f.close
end

def gen_location (loc)
    " generates a location with loc "
    res = "#===================================================================== Location\n"
    if $locations[loc] == nil then
        if loc == "NO LOCATION" then puts "⚠ Caution: No location."
        else puts "⚠ Caution: Unreferenced Location, or Uncap letter for #{loc}."end
        res += "\# Unreferenced Location.\n"
        res += "location=0\n"
        res += "woeid=1"
    else
        pos = $locations[loc]

        res += "\# #{loc} —— #{pos[3][0]}\n"
        res += "location=1\n"
        if $WorldWide == true then
            res +="woeid=1\n#{pos[0]}\n#{pos[1]}\n"
        else
            res +="woeid=#{pos[2]}\n#{pos[0]}\n#{pos[1]}\n"
        end
        res += "\# elevation env #{pos[3][1]}\n\n"
    end
    return res
end

def gen_colors ()
    "generate colors of the ui"
    res = ''
    $ui_colors.keys.each {
        |ii| res += "#{ii}=#{$ui_colors[ii]}\n"
    }
    return res + "\n"
end

def gen_header ()
    date = "YYYY-MM-DD (gotta code that for ruby 1.9)"
    #date = DateTime.now #Ruby 1.9
    res = "#{$line}\n# TTYTTER Settings #{date}\n#{$line}\n\n"
end

def gen_mainsettings ()

body = "simplestart=#{boo($start)}

hold=1
ssl=1
ansi=1
vcheck=1

dostream=1
mentions=#{boo($mentions)}
searchhits=#{$searchhits}
autosplit=#{boo($split)}

#shorturl=http://is.gd/api.php?longurl=

#==================================================================== Interface
urlopen=open -a Opera %U
avatar=curl -s %U > /tmp/ttytter-%N.%E && open -a /Applications/Media/Xee.app /tmp/ttytter-%N.%E

newline=1
notifytype=growl
notifies=dm,reply

#{gen_colors}"

    res = gen_header + body
return res
end

def intro ()
    h = "

NAME
       locate - locate ttytter rc file

SYNOPSIS
       locate [place name]

DESCRIPTION
       Generates the ttytter config file with some details.

AVAILABLE PLACES"
    $locations.keys.each { |loc| h += "\n"+"       #{loc}"}
    puts h
end

#===============================================================================
#==  Helpers  ==================================================================
#===============================================================================
def gen_stuff (title, liste, sep, container)
=begin
title: list, liste: list, sep: str used to separate variables, container: list of the two entities that contains
Generates a config usage string with a title formated as ('cfg variable', "header title")"
=end
    if title[1] != nil then res = "#" + "=" * ( 78 - (title[1].length + 1)) + " #{title[1]}\n#{title[0]}="
    else                    res = "#" + "=" * 78 + "\n#{title[0]}=" end

    if container != nil then res +=  "#{container[0]}"end

    if liste.eql? $filter then
        liste.each { |i| res += "/#{i}/i | "}
    else
        liste.each { |i| res += "#{i}#{sep}" }
    end

    if container != [] then res = res.slice(0..-3)
    else  res = res.slice(0..-2) end

    if container != nil then res += "#{container[1]}"end
    return res + "\n\n"
end

def boo (v)
    "retuns perl boolean"
    if v == false then return 0
    else return 1
    end
end

#= Helpers end =================================================================

main()
