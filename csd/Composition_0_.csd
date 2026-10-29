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
; KINETIC BLOOM
; Generative electronic sound environment
; ============================================

gkVolume init 0.58
gkDensity init 0.55
gkBrightness init 0.5
gkMotion init 0.5

; --------------------------------------------
; 1. Slowly evolving global parameters
; --------------------------------------------
instr 10
    kTime timeinsts

    kWave oscili 0.5, 0.00065, giSine
    kWave = kWave + 0.5

    gkDensity portk (0.30 + 0.40 * kWave), 6
    gkBrightness portk (0.25 + 0.50 * kWave), 8
    gkMotion portk (0.20 + 0.70 * kWave), 7
endin

; --------------------------------------------
; 2. Deep, breathing harmonic bed
; --------------------------------------------
instr 1
    kBreath oscili 0.25, 0.035, giSine

    a1 poscil 0.045, 49.00 * (1 + kBreath * 0.005), giSine
    a2 poscil 0.030, 65.41, giSine
    a3 poscil 0.020, 98.00, giSine
    a4 poscil 0.014, 130.81, giSine

    aMix = a1 + a2 + a3 + a4

    kCutoff = 700 + 4500 * gkBrightness
    aTone tone aMix, kCutoff

    kPanLfo oscili 0.45, 0.011, giSine
    kPan = 0.5 + kPanLfo * gkMotion

    aL, aR pan2 aTone * gkVolume, kPan
    outs aL, aR
endin

; --------------------------------------------
; 3. Percussive tonal voice
; --------------------------------------------
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.025, -5, 1, p3 - 0.025, -4, 0

    aFund poscil iAmp, iFreq, giSine
    aHarm poscil iAmp * 0.24, iFreq * 2.76, giSine
    aHigh poscil iAmp * 0.08, iFreq * 4.03, giSine

    aSig = (aFund + aHarm + aHigh) * aEnv * gkVolume

    aL, aR pan2 aSig, iPan
    outs aL, aR
endin

; --------------------------------------------
; 4. Irregular rhythmic stream
; --------------------------------------------
instr 3
    kRate = (0.8 + 1.0 * gkDensity)
    kTrig metro kRate

    if kTrig == 1 then
        kPick random 0, 7
        kOct random 0, 2
        kAmp random 0.012, 0.035
        kPan random 0.08, 0.92
        kDur random 0.25, 0.95

        kNote = int(kPick)

        if kNote == 0 then
            kFreq = 164.81
        elseif kNote == 1 then
            kFreq = 196.00
        elseif kNote == 2 then
            kFreq = 220.00
        elseif kNote == 3 then
            kFreq = 246.94
        elseif kNote == 4 then
            kFreq = 293.66
        elseif kNote == 5 then
            kFreq = 329.63
        elseif kNote == 6 then
            kFreq = 392.00
        else
            kFreq = 440.00
        endif

        kFreq = kFreq * (2 ^ int(kOct))

        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; --------------------------------------------
; 5. Low rhythmic pulses
; --------------------------------------------
instr 4
    kTrig metro (0.20 + gkDensity * 0.25)

    if kTrig == 1 then
        kFreq random 43, 62
        kAmp random 0.020, 0.040
        kPan random 0.40, 0.60

        event "i", 2, 0, 1.5, kFreq, kAmp, kPan
    endif
endin

; --------------------------------------------
; 6. High crystalline accents
; --------------------------------------------
instr 5
    kTrig metro (0.12 + gkDensity * 0.22)

    if kTrig == 1 then
        kPick random 0, 4
        kAmp random 0.004, 0.012
        kPan random 0.10, 0.90

        kIndex = int(kPick)

        if kIndex == 0 then
            kFreq = 587.33
        elseif kIndex == 1 then
            kFreq = 659.25
        elseif kIndex == 2 then
            kFreq = 783.99
        elseif kIndex == 3 then
            kFreq = 880.00
        else
            kFreq = 987.77
        endif

        event "i", 2, 0, 0.65, kFreq, kAmp, kPan
    endif
endin

</CsInstruments>

<CsScore>
i 10 0 86400
i 1  0 86400
i 3  0 86400
i 4  0 86400
i 5  0 86400
e
</CsScore>
</CsoundSynthesizer>
