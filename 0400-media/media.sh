question grab_media_files 'Get some media files? Music, Desktop wallpapers, ...' yes
function grab_media_files {
## get some music
mkdir -p "$USER_HOME/Music"


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



chown "$USER":"$USER" "$USER_HOME/Music"/*


}

