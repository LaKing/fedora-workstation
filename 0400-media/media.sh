question grab_media_files 'Get some media files? Music, Desktop wallpapers, ...' yes
function grab_media_files {
## get some music
mkdir -p "$USER_HOME/Music"

set_file "$USER_HOME/Music/brfm130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/brfm-128-aac
Title1=SomaFM: Black Rock FM (#1  ): From the Playa to the world, back for the 2015 Burning Man festival.
Length1=-1
File2=http://ice2.somafm.com/brfm-128-aac
Title2=SomaFM: Black Rock FM (#2  ): From the Playa to the world, back for the 2015 Burning Man festival.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/cliqhop64.pls" '[playlist]
numberofentries=2
File1=http://ice2.somafm.com/cliqhop-64-aac
Title1=SomaFM: cliqhop idm (#1  ): Blipsn beeps backed mostly w/beats. Intelligent Dance Music.
Length1=-1
File2=http://ice1.somafm.com/cliqhop-64-aac
Title2=SomaFM: cliqhop idm (#2  ): Blipsn beeps backed mostly w/beats. Intelligent Dance Music.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/deepspaceone130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/deepspaceone-128-aac
Title1=SomaFM: Deep Space One (#1  ): Deep ambient electronic, experimental and space music. For inner and outer space exploration.
Length1=-1
File2=http://ice2.somafm.com/deepspaceone-128-aac
Title2=SomaFM: Deep Space One (#2  ): Deep ambient electronic, experimental and space music. For inner and outer space exploration.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/dubstep64.pls" '[playlist]
numberofentries=2
File1=http://ice2.somafm.com/dubstep-64-aac
Title1=SomaFM: Dub Step Beyond (#1  ): Dubstep, Dub and Deep Bass. May damage speakers at high volume.
Length1=-1
File2=http://ice1.somafm.com/dubstep-64-aac
Title2=SomaFM: Dub Step Beyond (#2  ): Dubstep, Dub and Deep Bass. May damage speakers at high volume.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/groovesalad130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/groovesalad-128-aac
Title1=SomaFM: Groove Salad (#1  ): A nicely chilled plate of ambient/downtempo beats and grooves.
Length1=-1
File2=http://ice2.somafm.com/groovesalad-128-aac
Title2=SomaFM: Groove Salad (#2  ): A nicely chilled plate of ambient/downtempo beats and grooves.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/secretagent130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/secretagent-128-aac
Title1=SomaFM: Secret Agent (#1  ): The soundtrack for your stylish, mysterious, dangerous life. For Spies and PIs too!
Length1=-1
File2=http://ice2.somafm.com/secretagent-128-aac
Title2=SomaFM: Secret Agent (#2  ): The soundtrack for your stylish, mysterious, dangerous life. For Spies and PIs too!
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/silent130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/silent-128-aac
Title1=SomaFM: The Silent Channel (#1  ): Chilled ambient electronic music for calm inner atmospheres from Silent Records.
Length1=-1
File2=http://ice2.somafm.com/silent-128-aac
Title2=SomaFM: The Silent Channel (#2  ): Chilled ambient electronic music for calm inner atmospheres from Silent Records.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/thetrip64.pls" '[playlist]
numberofentries=2
File1=http://ice2.somafm.com/thetrip-64-aac
Title1=SomaFM: The Trip (#1  ): Progressive house / trance. Tip top tunes.
Length1=-1
File2=http://ice1.somafm.com/thetrip-64-aac
Title2=SomaFM: The Trip (#2  ): Progressive house / trance. Tip top tunes.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/u80s130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/u80s-128-aac
Title1=SomaFM: Underground 80s (#1  ): Early 80s UK Synthpop and a bit of New Wave.
Length1=-1
File2=http://ice2.somafm.com/u80s-128-aac
Title2=SomaFM: Underground 80s (#2  ): Early 80s UK Synthpop and a bit of New Wave.
Length2=-1
Version=2' 


chown "$USER":"$USER" "$USER_HOME/Music"/*


}

