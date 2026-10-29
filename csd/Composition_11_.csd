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
; Generative electronic ambient / self-contained synthesis
; ========================================================

; Main harmonic field
instr 1
    kBreath lfo 0.5, 0.035, 1
    kMotion lfo 0.7, 0.018, 1

    kCutoff = 900 + 650 * (kBreath + 1)
    kRoot = 55 * (1 + 0.018 * kMotion)

    a1 poscil 0.10, kRoot
    a2 poscil 0.045, kRoot * 1.5
    a3 poscil 0.028, kRoot * 2.01
    a4 poscil 0.018, kRoot * 3.97

    aField = a1 + a2 + a3 + a4
    aFiltered tone aField, kCutoff

    aEnv linen 1, 10, p3, 15
    aOut = aFiltered * aEnv

    aL, aR pan2 aOut, 0.5 + 0.18 * kMotion
    outs aL, aR

    ; Rhythmic events with a drifting pulse density
    kDensity lfo 1.1, 0.24, 1
    kDensity = 2.2 + kDensity

    kTrig metro kDensity

    if kTrig == 1 then
        kType random 0, 1
        kStep random 0, 9
        kFreq = 146.83 * (2 ^ (int(kStep) / 12))

        kDur random 0.12, 0.9
        kAmp random 0.025, 0.085
        kPan random 0.04, 0.96

        if kType < 0.32 then
            event "i", 3, 0, kDur, kFreq, kAmp, kPan
        else
            event "i", 2, 0, kDur * 2.8, kFreq * 2, kAmp * 0.7, kPan
        endif
    endif
endin

; Soft synthetic impact
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv expseg 0.001, 0.012, 1, p3 - 0.012, 0.001
    kPitch expseg 1.7, 0.035, 1, p3 - 0.035, 0.82

    aTone poscil iAmp, iFreq * kPitch
    aBody poscil iAmp * 0.35, iFreq * 0.5

    aSig = (aTone + aBody) * aEnv
    aL, aR pan2 aSig, iPan
    outs aL, aR
endin

; Short, bright electronic particle
instr 3
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.008, 1, 1, p3 * 0.35, -3, 0.001, p3 * 0.65, -4, 0

    kWobble lfo 0.012, 5.2, 1
    a1 poscil iAmp, iFreq * (1 + kWobble)
    a2 poscil iAmp * 0.28, iFreq * 2.76

    aSig = (a1 + a2) * aEnv
    aL, aR pan2 aSig, iPan
    outs aL, aR
endin

</CsInstruments>

<CsScore>
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
