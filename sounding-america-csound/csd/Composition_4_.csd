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
; Bright generative electronic environment
; Self-contained synthesis
; ========================================================

; Radiant harmonic field
instr 1
    kOrbit lfo 1, 0.017, 1
    kShimmer lfo 1, 0.041, 1
    kBreath lfo 1, 0.027, 1

    kRoot = 65.41 * (1 + 0.009 * kOrbit)
    kCut = 1800 + 1200 * (kShimmer + 1)

    a1 poscil 0.075, kRoot
    a2 poscil 0.043, kRoot * 1.5
    a3 poscil 0.025, kRoot * 2.003
    a4 poscil 0.016, kRoot * 4.01
    a5 poscil 0.009, kRoot * 6.02

    aField = a1 + a2 + a3 + a4 + a5
    aField tone aField, kCut

    aEnv linen 1, 10, p3, 14
    aOut = aField * aEnv * (0.88 + 0.12 * kBreath)

    aL, aR pan2 aOut, 0.5 + 0.18 * kOrbit
    outs aL, aR

    ; Rotating sequence of bright tones
    kRate lfo 1, 0.12, 1
    kRate = 2.0 + 1.4 * (kRate + 1)
    kTrig metro kRate

    if kTrig == 1 then
        kStep random 0, 12
        kFreq = 261.63 * (2 ^ (int(kStep) / 12))
        kDur random 0.18, 0.85
        kAmp random 0.018, 0.055
        kPan random 0.02, 0.98
        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif

    ; Warm mechanical pulse
    kPulse metro 0.72
    if kPulse == 1 then
        kFreq random 48, 72
        kAmp random 0.025, 0.055
        event "i", 3, 0, 0.42, kFreq, kAmp
    endif
endin

; Bright harmonic sparks
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.025, 1, 1, p3 * 0.32, -2, 0.001, p3 * 0.645, -3, 0

    kWobble lfo 0.006, 0.3, 1

    a1 poscil iAmp, iFreq * (1 + kWobble)
    a2 poscil iAmp * 0.28, iFreq * 2.01
    a3 poscil iAmp * 0.12, iFreq * 3.97

    aSpark = (a1 + a2 + a3) * aEnv

    kPan lfo 0.18, 0.2, 1
    aL, aR pan2 aSpark, limit(iPan + kPan, 0.02, 0.98)
    outs aL, aR
endin

; Warm low-frequency pulse
instr 3
    iFreq = p4
    iAmp = p5

    aEnv expseg 0.001, 0.025, 1, 0.395, 0.001
    kPitch expseg 1.55, 0.08, 1, 0.34, 0.8

    a1 poscil iAmp, iFreq * kPitch
    a2 poscil iAmp * 0.2, iFreq * 2

    aPulse = (a1 + a2) * aEnv
    aL, aR pan2 aPulse, 0.5
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; Long-form generative session: 24 hours
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
