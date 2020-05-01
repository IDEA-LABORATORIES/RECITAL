MAD Final Project
===

# Recital

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)
1. [Video Walkthrough](#Video-Walkthrough)


## Overview
### Description
Recital reduces the amount of time musicicans spend learning new songs.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] User can play audio files.
* [x] User can seek through audio.
* [x] User can slow down music and audio.
* [x] User is shown note values in real time.

**Optional Nice-to-have Stories**

* [x] User can adjust pitch of audio
* [x] Waveform view
* [ ] A/B Looping
* [x] User can filter low and high frequencies
* [ ] User can save edited audio

### 2. Screen Archetypes

* Editor / Control Panel (airplane)
* File Selection

### 3. Navigation

**Flow Navigation** (Screen to Screen)

* Control Panel
   * => File Selection

* File Selection
   * => Control Panel

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/IDEA-LABORATORIES/RECITAL/blob/master/Wireframe_sketch.jpeg" width=600>

## Schema 
### Models

| Property | Type | Description |
| --- | --- | --- |
| AudioFile | File | File of the audio selected by the user |
| AudioSpeed | Float | Speed of the audio playback set by user |
| AudioPitch | Float | Pitch/Key of the audio algorithmically analyzed and presented to the user in real time |

### Networking
N/A

## Video Walkthrough
### User can play and seek through their selected audio file
<a href="https://imgflip.com/gif/3vrn7e"><img src="https://i.imgflip.com/3vrn7e.gif" title=""/></a>

### User can change rate of audio playback
<a href="https://imgflip.com/gif/3x410e"><img src="https://i.imgflip.com/3x410e.gif" title=""/></a>

### User can view notes of song in realtime
<a href="https://imgflip.com/gif/3x5v89"><img src="https://i.imgflip.com/3x5v89.gif" title=""/></a>

### User can filter high and low frequencies
<a href="https://imgflip.com/gif/3xk9j0"><img src="https://i.imgflip.com/3xk9j0.gif" title=""/></a>
