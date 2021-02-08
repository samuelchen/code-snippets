#!/usr/bin/env python3

"""
Caculate required bandwidth for media broadcast


https://support.google.com/youtube/answer/1722171?hl=en

#### Recommended video bitrates for SDR uploads

To view new 4K uploads in 4K, use a browser or device that supports VP9.

| Type       | Video Bitrate, Standard Frame Rate (24, 25, 30) | Video Bitrate, High Frame Rate (48, 50, 60) |
| :--------- | :---------------------------------------------- | :------------------------------------------ |
| 2160p (4K) | 35–45 Mbps                                      | 53–68 Mbps                                  |
| 1440p (2K) | 16 Mbps                                         | 24 Mbps                                     |
| 1080p      | 8 Mbps                                          | 12 Mbps                                     |
| 720p       | 5 Mbps                                          | 7.5 Mbps                                    |
| 480p       | 2.5 Mbps                                        | 4 Mbps                                      |
| 360p       | 1 Mbps                                          | 1.5 Mbps                                    |

#### Recommended video bitrates for HDR uploads

| Type       | Video Bitrate, Standard Frame Rate (24, 25, 30) | Video Bitrate, High Frame Rate (48, 50, 60) |
| :--------- | :---------------------------------------------- | :------------------------------------------ |
| 2160p (4K) | 44–56 Mbps                                      | 66–85 Mbps                                  |
| 1440p (2K) | 20 Mbps                                         | 30 Mbps                                     |
| 1080p      | 10 Mbps                                         | 15 Mbps                                     |
| 720p       | 6.5 Mbps                                        | 9.5 Mbps                                    |
| 480p       | Not supported                                   | Not supported                               |
| 360p       | Not supported                                   | Not supported                               |

#### Recommended audio bitrates for uploads

| Type   | Audio Bitrate |
| :----- | :------------ |
| Mono   | 128 kbps      |
| Stereo | 384 kbps      |
| 5.1    | 512 kbps      |


----------

Resoution * FPS * compress_rate = bit_rate


"""

from collections import namedtuple

Resolution = namedtuple('Resolution', ('width', 'height'))
#  MediaEncodingFormat = namedtuple('MediaFormat', ('bitrate', ))
#  MediaPackagFormat = namedtuple('MediaFormat', ('bitrate', ))


Mbps = 1024 * 1024
Kbps = 1024


class ScreenResolution16x9:
    R240P = Resolution(426, 240)
    R360P = Resolution(640, 360)
    R480P = Resolution(854, 480)
    R720P = Resolution(1280, 720)
    R1080P = Resolution(1920, 1080)
    R1440P = Resolution(2560, 1440)
    R2160P = Resolution(3840, 2160)
    R4320P = Resolution(7580, 4320)

    SD240 = R240P
    SD360 = Resolution(640, 360)
    SD480 = Resolution(854, 480)
    HD720 = Resolution(1280, 720)
    FHD = Resolution(1920, 1080)
    UHD2K = Resolution(2560, 1440)
    UHD4K = Resolution(3840, 2160)
    UHD8K = Resolution(7580, 4320)


class StandardFPS:
    MOVIE_CLASSIC = 22
    MOVIE = 24
    MOVIE1 = 25
    VIDEO = 30


class HighFPS:
    MOVIE_CLASSIC = 44
    MOVIE = 48
    MOVIE1 = 50
    VIDEO = 60


class BitRateSDR:

    # standard FPS
    S360P = 1 * Mbps
    S480P = 2.5 * Mbps
    S720P = 5 * Mbps
    S1080P = 8 * Mbps
    S1440P = 16 * Mbps
    S2160P = (35 * Mbps, 45 * Mbps)

    # high FPS
    H360P = 1.5 * Mbps
    H480P = 4 * Mbps
    H720P = 7.5 * Mbps
    H1080P = 12 * Mbps
    H1440P = 24 * Mbps
    H2160P = (53 * Mbps, 68 * Mbps)


class BitRateHDR:

    # standard FPS
    S720P = 6.5 * Mbps
    S1080P = 10 * Mbps
    S1440P = 20 * Mbps
    S2160P = (44 * Mbps, 56 * Mbps)

    # high FPS
    H720P = 9.5 * Mbps
    H1080P = 15 * Mbps
    H1440P = 30 * Mbps
    H2160P = (66 * Mbps, 85 * Mbps)


class BitRateAudio:
    MONO = 128 * Kbps
    STEREO = 384 * Kbps
    STEREO_5_1 = 512 * Kbps


#  class VideoEncodingRate:
#      H264 = 150      # 150 ~ 250 : 1
#      H265 = 300      # 300 ~ 500 : 1
#      VP9
#
#
#  class VideoPackaging:
#      MPEG2
#      MP2 = MPEG2
#      MPEG4
#      MP4 = MPEG4


def calc_video_bw(w=1920, h=1080, rgb=24, fps=24, rate):
    """Calculate video bandwidth

    arguments:
    w:  `int`, optional, default 1920
        width of single frame image (pixel)
    h:  `int`, optional, default 1080
        height of single frame image (pixel)
    rgb:`int`, optional, default 24
        bits for RGB color (commonly one of 8,16,24,32)
    fps:`int`, optional, default 24
        how may frames per second for playing (commonly 24 for movie, 30 for video)
    """
    pass

