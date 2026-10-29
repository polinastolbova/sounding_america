<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>

<CsInstruments>
sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1

giSine ftgen 1, 0, 16384, 10, 1

; ============================================
; Flowing currents / generative soundscape
; ============================================

gkVolume init 0.60
gkMotion init 0.5
gkDensity init 0.55
gkBrightness init 0.5

; --------------------------------------------
; 1. Slow evolution controller
; --------------------------------------------
instr 10
    kTime timeinsts

    kWave oscili 0.5, 0.0008, giSine
    kWave = kWave + 0.5

    kDensityTarget = 0.30 + 0.42 * kWave
    gkDensity portk kDensityTarget, 7

    kBrightTarget = 0.25 + 0.55 * kWave
    gkBrightness portk kBrightTarget, 9

    kMotionTarget = 0.15 + 0.75 * kWave
    gkMotion portk kMotionTarget, 8
endin

; --------------------------------------------
; 2. Flowing harmonic drone
; --------------------------------------------
instr 1
    kDrift oscili 0.3, 0.017, giSine

    a1 poscil 0.045, 55 * (1 + kDrift * 0.01), giSine
    a2 poscil 0.026, 73.42, giSine
    a3 poscil 0.022, 110.0 * (1 - kDrift * 0.005), giSine
    a4 poscil 0.018, 146.83, giSine

    aMix = a1 + a2 + a3 + a4

    kCutoff = 600 + gkBrightness * 6000
    aFiltered tone aMix, kCutoff

    kPan oscili 0.5, 0.013, giSine
    kPan = 0.5 + kPan * gkMotion

    aL, aR pan2 aFiltered * gkVolume, kPan
    outs aL, aR
endin

; --------------------------------------------
; 3. Moving pulse
; --------------------------------------------
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.08, -4, 1, p3 - 0.08, -4, 0

    kWobble oscili 0.015, 0.09, giSine
    aTone poscil iAmp, iFreq * (1 + kWobble), giSine
    aSub poscil iAmp * 0.3, iFreq * 0.5, giSine

    aSig = (aTone + aSub) * aEnv * gkVolume

    aL, aR pan2 aSig, iPan
    outs aL, aR
endin

; --------------------------------------------
; 4. Generative melodic stream
; --------------------------------------------
instr 3
    kRate = 0.55 + gkDensity * 1.1
    kTrig metro kRate

    if kTrig == 1 then
        kPick random 0, 7
        kOct random 0, 2
        kAmp random 0.012, 0.038
        kPan random 0.08, 0.92
        kDur random 0.7, 2.2

        kNote = int(kPick)

        if kNote == 0 then
            kFreq = 130.81
        elseif kNote == 1 then
            kFreq = 146.83
        elseif kNote == 2 then
            kFreq = 174.61
        elseif kNote == 3 then
            kFreq = 196.00
        elseif kNote == 4 then
            kFreq = 220.00
        elseif kNote == 5 then
            kFreq = 261.63
        elseif kNote == 6 then
            kFreq = 293.66
        else
            kFreq = 349.23
        endif

        kFreq = kFreq * (2 ^ int(kOct))

        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; --------------------------------------------
; 5. Low-frequency breathing pulses
; --------------------------------------------
instr 4
    kRate = 0.18 + gkDensity * 0.22
    kTrig metro kRate

    if kTrig == 1 then
        kFreq random 45, 68
        kAmp random 0.018, 0.040
        kPan random 0.35, 0.65

        event "i", 2, 0, 2.4, kFreq, kAmp, kPan
    endif
endin

; --------------------------------------------
; 6. High shimmering details
; --------------------------------------------
instr 5
    kRate = 0.12 + gkDensity * 0.18
    kTrig metro kRate

    if kTrig == 1 then
        kFreq random 523.25, 1046.5
        kAmp random 0.004, 0.014
        kPan random 0.1, 0.9

        event "i", 2, 0, 1.1, kFreq, kAmp, kPan
    endif
endin

</CsInstruments>

<CsScore>
; Continuous performance for up to 24 hours
i 10 0 86400
i 1  0 86400
i 3  0 86400
i 4  0 86400
i 5  0 86400
e
</CsScore>
</CsoundSynthesizer>
