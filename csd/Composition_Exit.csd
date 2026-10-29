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
; Organic pulse / generative electronic ambience
; ============================================

gkVolume init 0.58
gkDensity init 0.55
gkBrightness init 0.5
gkMotion init 0.5

; --------------------------------------------
; 1. Autonomous macro evolution
; --------------------------------------------
instr 10
    kA oscili 0.5, 0.0009, giSine
    kA = kA + 0.5

    kB oscili 0.5, 0.0013, giSine
    kB = kB + 0.5

    gkDensity portk (0.35 + 0.38 * kA), 6
    gkBrightness portk (0.25 + 0.5 * kB), 8
    gkMotion portk (0.2 + 0.7 * kA), 7
endin

; --------------------------------------------
; 2. Warm evolving drone
; --------------------------------------------
instr 1
    kDrift oscili 0.2, 0.023, giSine

    a1 poscil 0.043, 55 * (1 + kDrift * 0.008), giSine
    a2 poscil 0.025, 82.41, giSine
    a3 poscil 0.018, 110 * (1 - kDrift * 0.005), giSine
    a4 poscil 0.012, 164.81, giSine

    aMix = a1 + a2 + a3 + a4

    kCutoff = 800 + 4800 * gkBrightness
    aFiltered tone aMix, kCutoff

    kPanLfo oscili 0.45, 0.012, giSine
    kPan = 0.5 + kPanLfo * gkMotion

    aL, aR pan2 aFiltered * gkVolume, kPan
    outs aL, aR
endin

; --------------------------------------------
; 3. Rounded percussive voice
; --------------------------------------------
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.025, -5, 1, p3 - 0.025, -4, 0

    aFund poscil iAmp, iFreq, giSine
    aHarm poscil iAmp * 0.16, iFreq * 2.4, giSine

    aSig = (aFund + aHarm) * aEnv * gkVolume

    aL, aR pan2 aSig, iPan
    outs aL, aR
endin

; --------------------------------------------
; 4. Syncopated midrange activity
; --------------------------------------------
instr 3
    kRate = 0.8 + gkDensity * 1.3
    kTrig metro kRate

    if kTrig == 1 then
        kPick random 0, 7
        kAmp random 0.012, 0.034
        kPan random 0.08, 0.92
        kDur random 0.25, 0.85
        kOct random 0, 2

        kNote = int(kPick)

        if kNote == 0 then
            kFreq = 146.83
        elseif kNote == 1 then
            kFreq = 164.81
        elseif kNote == 2 then
            kFreq = 196.00
        elseif kNote == 3 then
            kFreq = 220.00
        elseif kNote == 4 then
            kFreq = 246.94
        elseif kNote == 5 then
            kFreq = 293.66
        elseif kNote == 6 then
            kFreq = 329.63
        else
            kFreq = 392.00
        endif

        kFreq = kFreq * (2 ^ int(kOct))
        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; --------------------------------------------
; 5. Sub pulse
; --------------------------------------------
instr 4
    kTrig metro (0.22 + gkDensity * 0.20)

    if kTrig == 1 then
        kFreq random 45, 61
        kAmp random 0.018, 0.032

        event "i", 2, 0, 1.7, kFreq, kAmp, 0.5
    endif
endin

; --------------------------------------------
; 6. Metallic high details
; --------------------------------------------
instr 5
    kTrig metro (0.12 + gkDensity * 0.20)

    if kTrig == 1 then
        kPick random 0, 4
        kAmp random 0.004, 0.012
        kPan random 0.1, 0.9

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
            kFreq = 1046.5
        endif

        event "i", 2, 0, 0.7, kFreq, kAmp, kPan
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
