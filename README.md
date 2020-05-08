# Recital: Music speed changer and transcriber
## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)
1. [Video Walkthrough](#Video-Walkthrough)
2. [UI Progress](#UI-Progress)

## Overview
### Description (Business Thesis)
Musicians will use 
Recitals speed changing and note transcription to 
learn songs faster.

Recital is helps musicians practicing songs that may not have conventional music notations such as sheet music or tablature by providing realtime transcription and the ability to change audio speed/pitch.

You can use any Apple audio file such as WAV, MP3 or M4A.

#### Customer Discovery
Customer Segment: Musicians (Guitarists, Pianists, Violinists)

Customer Interviews: 51 interviews with musicians and music teachers.

#### Problems Indentified
##### Inaccurate / lack of music notation particularly  for contemporary music.
* 8/38 players

##### Lack of musical skill/knowledge particularly ear training because it is boring.
* 10/38 players

#### Interview Questions
* What is your name? 
* What is your age? 
* How long have you played your instrument? 
* What is your goal in learning/playing this instrument? For example, learning to play songs.
* Can you walk me through your process for your stated goal?
* What barriers have you encountered while working towards these goals 
* What is frustrating when working to overcome these barriers? 
* Is there anything you wish you had to help?
* Follow up with 5 Whys or other relevant questions.

#### Revenue Model
* Freemium



## Product Spec

### User Stories (Required and Optional)
**Required Must-have Stories**
* [x] Playback - Use audio player to playback file.
* [x] Transcription - View audio note values in real time.
* [x] Speed Change - Change speed of audio from .25 to 2 times the original speed.
* [x] Bandwidth Filter - Filter desired frequencies.
* [x] Waveform View - View waveform of audio synchronized with playback.
* [x] A/B Looping - Loop selected section of audio. 
* [x] Pitch Shift - Shift pitch up or down up to 24 semi-tones 

**Optional Nice-to-have Stories**
* [ ] User can save edited audio

### Screen Archetypes

* Recital View Controller
* File Selection

### Navigation

**Flow Navigation** (Screen to Screen)

* Recital View Controller => File Selection

* File Selection => Recital View Controller

## Wireframes
<img src="https://github.com/IDEA-LABORATORIES/RECITAL/blob/master/handsketch_to_illustrator.png" width=600>

## Schema 
### Models

| Property | Type | Description |
| --- | --- | --- |
| AudioFile | File | File of the audio selected by the user |
| AudioSpeed | Float | Speed of the audio playback set by user |
| AudioPitch | Float | Pitch/Key of the audio algorithmically analyzed and presented to the user in real time |
| FilterFrequency | Float | Frequency user wants to hear |
| FilterWidth | Float | Width of bandwidth filter |

### Networking
N/A

## Video Walkthrough
### Playback - Use audio player to playback file.
<a href="https://imgflip.com/gif/40ksh3"><img src="https://i.imgflip.com/40ksh3.gif" title=""/></a>
### Transcription - View audio note values in real time.
<a href="https://imgflip.com/gif/40ksvm"><img src="https://i.imgflip.com/40ksvm.gif" title=""/></a>
### Speed Change - Change speed of audio from .25 to 2 times the original speed.
<a href="https://imgflip.com/gif/40ktcw"><img src="https://i.imgflip.com/40ktcw.gif" title=""/></a>
### Bandwidth Filter - Filter desired frequencies.
<a href="https://imgflip.com/gif/40mk1d"><img src="https://i.imgflip.com/40mk1d.gif" title=""/></a>
### Waveform View - View waveform of audio synchronized with playback.
<a href="https://imgflip.com/gif/40mk93"><img src="https://i.imgflip.com/40mk93.gif" title=""/></a>
### A/B Looping - Loop selected section of audio.
<a href="https://imgflip.com/gif/40mkdd"><img src="https://i.imgflip.com/40mkdd.gif" title=""/></a>
### Pitch Shift - Shift pitch up or down up to 24 semi-tones.
<a href="https://imgflip.com/gif/40mkk2"><img src="https://i.imgflip.com/40mkk2.gif" title=""/></a>

## UI Progress
<a href="https://imgflip.com/gif/3vrn7e"><img src="https://i.imgflip.com/3vrn7e.gif" title=""/></a>

<a href="https://imgflip.com/gif/3x410e"><img src="https://i.imgflip.com/3x410e.gif" title=""/></a>

<a href="https://imgflip.com/gif/3x5v89"><img src="https://i.imgflip.com/3x5v89.gif" title=""/></a>

<a href="https://imgflip.com/gif/3xk9j0"><img src="https://i.imgflip.com/3xk9j0.gif" title=""/></a>
