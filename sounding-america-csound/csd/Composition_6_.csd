<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>

<CsInstruments>
sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1

; ========================================================
; Moving synthetic soundscape
; No external samples
; ========================================================

; Main spatial drone
instr 1
    kMove1 lfo 1, 0.018, 1
    kMove2 lfo 1, 0.011, 1
    kBreath lfo 1, 0.035, 1

    kRoot = 52 * (1 + 0.012 * kMove1)
    kCutoff = 1200 + 900 * (kBreath + 1)

    a1 poscil 0.085, kRoot
    a2 poscil 0.043, kRoot * 1.498
    a3 poscil 0.023, kRoot * 2.004
    a4 poscil 0.014, kRoot * 3.01

    aMix = a1 + a2 + a3 + a4
    aFiltered tone aMix, kCutoff

    aEnv linen 1, 12, p3, 15
    aOut = aFiltered * aEnv

    kPan = 0.5 + 0.34 * kMove2
    aL, aR pan2 aOut, kPan
    outs aL, aR

    ; Moving particles appear at irregular intervals
    kDensity lfo 1, 0.13, 1
    kDensity = 1.7 + kDensity
    kTrig metro kDensity

    if kTrig == 1 then
        kDegree random 0, 12
        kFreq = 130.81 * (2 ^ (int(kDegree) / 12))
        kDur random 0.5, 2.8
        kAmp random 0.025, 0.075
        kStartPan random 0.02, 0.98
        kSpeed random 0.04, 0.22

        event "i", 2, 0, kDur, kFreq, kAmp, kStartPan, kSpeed
    endif
endin

; Spatially moving resonant particles
instr 2
    iFreq = p4
    iAmp = p5
    iStartPan = p6
    iSpeed = p7

    iPartial random 1.99, 3.03

    aEnv transeg 0, 0.06, 1, 1, p3 * 0.45, -2, 0.25, p3 * 0.49, -3, 0

    kTravel lfo 1, iSpeed, 1
    kPan = limit(iStartPan + 0.45 * kTravel, 0.01, 0.99)

    kWobble lfo 0.009, 0.21, 1
    a1 poscil iAmp, iFreq * (1 + kWobble)
    a2 poscil iAmp * 0.32, iFreq * iPartial

    aSignal = (a1 + a2) * aEnv

    aL, aR pan2 aSignal, kPan
    outs aL, aR
endin

; Low resonant events
instr 3
    iFreq = p4
    iAmp = p5

    aEnv expseg 0.001, 0.035, 1, p3 - 0.035, 0.001
    kPitch expseg 1.4, 0.12, 1, p3 - 0.12, 0.82

    aBody poscil iAmp, iFreq * kPitch
    aHarm poscil iAmp * 0.22, iFreq * 2.03

    aSignal = (aBody + aHarm) * aEnv
    aL, aR pan2 aSignal, 0.5
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; 24-hour generative session
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
