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
; TIDAL MACHINES
; Moving electronic architecture
; ============================================

gkVolume init 0.58
gkDensity init 0.55
gkBrightness init 0.5
gkMotion init 0.5

; --------------------------------------------
; 1. Slow independent motion cycles
; --------------------------------------------
instr 10
    kA oscili 0.5, 0.00055, giSine
    kA = kA + 0.5

    kB oscili 0.5, 0.00091, giSine
    kB = kB + 0.5

    kC oscili 0.5, 0.00137, giSine
    kC = kC + 0.5

    gkDensity portk (0.32 + 0.38 * kA), 7
    gkBrightness portk (0.25 + 0.48 * kB), 8
    gkMotion portk (0.18 + 0.72 * kC), 8
endin

; --------------------------------------------
; 2. Wide harmonic field
; --------------------------------------------
instr 1
    kDrift1 oscili 0.22, 0.018, giSine
    kDrift2 oscili 0.18, 0.027, giSine

    a1 poscil 0.040, 55 * (1 + kDrift1 * 0.006), giSine
    a2 poscil 0.025, 73.42 * (1 + kDrift2 * 0.005), giSine
    a3 poscil 0.020, 110.0, giSine
    a4 poscil 0.013, 146.83 * (1 + kDrift1 * 0.004), giSine

    aMix = a1 + a2 + a3 + a4

    kCut = 750 + 5000 * gkBrightness
    aFiltered tone aMix, kCut

    kPan oscili 0.45, 0.008, giSine
    kPan = 0.5 + kPan * gkMotion

    aL, aR pan2 aFiltered * gkVolume, kPan
    outs aL, aR
endin

; --------------------------------------------
; 3. Moving tonal sequences
; --------------------------------------------
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.035, -4, 1, p3 - 0.035, -4, 0

    kFM oscili 0.009, 0.08, giSine

    a1 poscil iAmp, iFreq * (1 + kFM), giSine
    a2 poscil iAmp * 0.15, iFreq * 2.5, giSine

    aSig = (a1 + a2) * aEnv * gkVolume

    aL, aR pan2 aSig, iPan
    outs aL, aR
endin

; --------------------------------------------
; 4. Generative moving sequence
; --------------------------------------------
instr 3
    kRate = 0.75 + gkDensity * 1.35
    kTrig metro kRate

    if kTrig == 1 then
        kPick random 0, 7
        kOct random 0, 2
        kAmp random 0.012, 0.032
        kPan random 0.08, 0.92
        kDur random 0.35, 1.15

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
; 5. Deep slow pulses
; --------------------------------------------
instr 4
    kTrig metro (0.18 + gkDensity * 0.18)

    if kTrig == 1 then
        kFreq random 41, 58
        kAmp random 0.018, 0.033

        event "i", 2, 0, 2.2, kFreq, kAmp, 0.5
    endif
endin

; --------------------------------------------
; 6. Floating upper harmonics
; --------------------------------------------
instr 5
    kTrig metro (0.10 + gkDensity * 0.17)

    if kTrig == 1 then
        kPick random 0, 4
        kAmp random 0.004, 0.012
        kPan random 0.10, 0.90

        kNote = int(kPick)

        if kNote == 0 then
            kFreq = 523.25
        elseif kNote == 1 then
            kFreq = 587.33
        elseif kNote == 2 then
            kFreq = 698.46
        elseif kNote == 3 then
            kFreq = 783.99
        else
            kFreq = 932.33
        endif

        event "i", 2, 0, 1.0, kFreq, kAmp, kPan
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
