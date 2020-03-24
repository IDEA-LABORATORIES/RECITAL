MAD Final Project
===

# Recital

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Recital reduces the amount of time musicicans spend learning new songs.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can play audio files.
* User can scrub through audio.
* User can slow down music and audio.
* User is shown key/pitch in real time.

**Optional Nice-to-have Stories**

* User can add loops and flags to organize audio.
* User can adjust pitch of audio
* User can filter low and high frequencies
* User can save edited audio

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
