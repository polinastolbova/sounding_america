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
; Autonomous generative soundscape
; ============================================

gkVolume init 0.58
gkDensity init 0.55
gkMotion init 0.5
gkBrightness init 0.5

; --------------------------------------------
; 1. Slow modulation system
; --------------------------------------------
instr 10
    kTime timeinsts

    kA oscili 0.5, 0.0007, giSine
    kA = kA + 0.5

    kB oscili 0.5, 0.0011, giSine
    kB = kB + 0.5

    gkDensity portk (0.30 + 0.40 * kA), 7
    gkMotion portk (0.15 + 0.75 * kB), 8
    gkBrightness portk (0.30 + 0.45 * kA), 10
endin

; --------------------------------------------
; 2. Intersecting harmonic currents
; --------------------------------------------
instr 1
    kMod1 oscili 0.25, 0.021, giSine
    kMod2 oscili 0.20, 0.031, giSine

    kF1 = 55 * (1 + kMod1 * 0.012)
    kF2 = 82.41 * (1 + kMod2 * 0.008)

    a1 poscil 0.045, kF1, giSine
    a2 poscil 0.026, kF2, giSine
    a3 poscil 0.020, 110.0 * (1 + kMod1 * 0.004), giSine
    a4 poscil 0.015, 164.81 * (1 + kMod2 * 0.006), giSine

    aMix = a1 + a2 + a3 + a4

    kCut = 700 + 5000 * gkBrightness
    aFiltered tone aMix, kCut

    kPan oscili 0.45, 0.009, giSine
    kPan = 0.5 + kPan * gkMotion

    aL, aR pan2 aFiltered * gkVolume, kPan
    outs aL, aR
endin

; --------------------------------------------
; 3. Resonant moving particles
; --------------------------------------------
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.04, -4, 1, p3 - 0.04, -4, 0

    kFM oscili 0.012, 0.07, giSine
    aFund poscil iAmp, iFreq * (1 + kFM), giSine
    aPartial poscil iAmp * 0.18, iFreq * 2.71, giSine

    aSig = (aFund + aPartial) * aEnv * gkVolume

    aL, aR pan2 aSig, iPan
    outs aL, aR
endin

; --------------------------------------------
; 4. Irregular note generation
; --------------------------------------------
instr 3
    kRate = 0.65 + gkDensity * 1.25
    kTrig metro kRate

    if kTrig == 1 then
        kPick random 0, 7
        kOct random 0, 2
        kAmp random 0.012, 0.035
        kPan random 0.05, 0.95
        kDur random 0.45, 1.8

        kNote = int(kPick)

        if kNote == 0 then
            kFreq = 146.83
        elseif kNote == 1 then
            kFreq = 174.61
        elseif kNote == 2 then
            kFreq = 196.00
        elseif kNote == 3 then
            kFreq = 220.00
        elseif kNote == 4 then
            kFreq = 261.63
        elseif kNote == 5 then
            kFreq = 293.66
        elseif kNote == 6 then
            kFreq = 349.23
        else
            kFreq = 392.00
        endif

        kFreq = kFreq * (2 ^ int(kOct))
        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; --------------------------------------------
; 5. Low rounded pulses
; --------------------------------------------
instr 4
    kTrig metro (0.18 + gkDensity * 0.22)

    if kTrig == 1 then
        kFreq random 43, 65
        kAmp random 0.018, 0.035
        kPan random 0.35, 0.65

        event "i", 2, 0, 2.0, kFreq, kAmp, kPan
    endif
endin

; --------------------------------------------
; 6. High floating tones
; --------------------------------------------
instr 5
    kTrig metro (0.10 + gkDensity * 0.18)

    if kTrig == 1 then
        kPick random 0, 4
        kAmp random 0.004, 0.013
        kPan random 0.10, 0.90

        kIndex = int(kPick)

        if kIndex == 0 then
            kFreq = 523.25
        elseif kIndex == 1 then
            kFreq = 587.33
        elseif kIndex == 2 then
            kFreq = 698.46
        elseif kIndex == 3 then
            kFreq = 783.99
        else
            kFreq = 880.00
        endif

        event "i", 2, 0, 1.1, kFreq, kAmp, kPan
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
