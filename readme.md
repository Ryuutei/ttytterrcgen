# TTYtterRC generator

Generates a .ttytterrc file for [TTYtter](http://www.floodgap.com/software/ttytter/)
with a "_Database_" you can edit.

I made this script because I don't like the way regex is written in perl :p and change my location. But honnestly if you really need to often change your location use the plugin [multi-geo by Ivan Sanchez Ortega](http://ivan.sanchezortega.es/ttytter/) Which is pretty impressive and usable inside TTYtter.

## Licence:

WTFPL (see LICENCE file)

## Configuration:

- Change the first variables of the script. ie. _$start, $mention, $friends, $track, etc._ (down to line 15)

- If you want the command /trend to retrieve worldwide trending  just type true after $worldwide.


**The _Database_ is for more "complex" configuration.**

- Add your friends to the $friends list.

- You can also change the UI colors.

- For plugins I have plenty I don't use so it's a simple list of paths.

- at last you can use built in location or add them manually like:

`"location name (the string you will use in the shell)" => 
    [ 'lat', 'long' , trendid/woeid , [ "timezone", "elevation",] ]`

( The trendid/woeid is an integer. As for the timezone and elevations it's just useless stuff. )


### Notes:

TTYtter still don't have the option to automatically adds lists to the timeline. so the list $lists has no use for now on.


## Usage:
    
    `ttytterrcgen.rb <location>`

if the location contains spaces you must type:

    `ttytterrcgen.rb "<location>"`

## Example:

`ttytterrcgen.rb Shanghai`

`ttytterrcgen.rb "Cap Breton"`

## Stuff I didn't code:

- configuration stuff I don't use... 
- things I never change. (ssh/ansi/ or like the /url command output stuff...) 
- I should add the hold option...

... I may add these later ...

## Final note:

Yes this script is pretty useless, the configuration file isn't that complicated to fill, but really I'm lazy. hehe
