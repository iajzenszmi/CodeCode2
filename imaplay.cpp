//generate a C++ program which is a media player for mp4 mp3 tracks

#include <iostream>
#include <string>
#include <cstdlib>
#include "windows.h"

using namespace std;

int main()
{
    string trackName;
    cout << "Enter the name of the track you want to play" << endl;
    getline(cin, trackName);

    string trackType;
    cout << "Is it an mp3 or mp4 track?" << endl;
    getline(cin, trackType);

    if (trackType == "mp3")
    {
        string mp3Command = "mplayer " + trackName;
        system(mp3Command.c_str());
    }
    else if (trackType == "mp4")
    {
        string mp4Command = "mplayer " + trackName;
        system(mp4Command.c_str());
    }
    else
    {
        cout << "Invalid track type" << endl;
    }
    return 0;
}
