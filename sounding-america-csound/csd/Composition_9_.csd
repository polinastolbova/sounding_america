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
; Organic generative soundscape
; No external samples
; ========================================================

; Main living harmonic environment
instr 1
    kBreath lfo 0.5, 0.025, 1
    kDrift lfo 1, 0.013, 1
    kPulse lfo 0.4, 0.09, 1

    kRoot = 48 * (1 + 0.012 * kDrift)
    kFilter = 1000 + 700 * (kBreath + 1)

    a1 poscil 0.10, kRoot
    a2 poscil 0.045, kRoot * 1.498
    a3 poscil 0.027, kRoot * 2.003
    a4 poscil 0.016, kRoot * 3.01

    aCloud = a1 + a2 + a3 + a4
    aCloud tone aCloud, kFilter

    aBreathEnv = 0.76 + 0.24 * kPulse
    aEnv linen 1, 12, p3, 16

    aOut = aCloud * aBreathEnv * aEnv
    aL, aR pan2 aOut, 0.5 + 0.15 * kDrift
    outs aL, aR

    ; The system changes its event density organically
    kDensity lfo 1.0, 0.11, 1
    kDensity = 1.8 + kDensity

    kTrig metro kDensity

    if kTrig == 1 then
        kKind random 0, 1
        kDegree random 0, 11
        kFreq = 130.81 * (2 ^ (int(kDegree) / 12))

        kDuration random 0.3, 2.4
        kAmplitude random 0.025, 0.075
        kPosition random 0.03, 0.97

        if kKind < 0.48 then
            event "i", 2, 0, kDuration, kFreq, kAmplitude, kPosition
        else
            event "i", 3, 0, kDuration * 1.5, kFreq * 1.51, kAmplitude * 0.65, kPosition
        endif
    endif
endin

; Rounded, resonant organic tones
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    iPartial random 1.98, 2.04
    iPartial2 random 2.97, 3.06

    aEnv transeg 0, 0.06, 1, 1, p3 * 0.4, -2, 0.3, p3 * 0.6, -3, 0

    kBend lfo 0.009, 0.23, 1

    aFund poscil iAmp, iFreq * (1 + kBend)
    aSecond poscil iAmp * 0.38, iFreq * iPartial
    aThird poscil iAmp * 0.13, iFreq * iPartial2

    aBody = (aFund + aSecond + aThird) * aEnv

    aL, aR pan2 aBody, iPan
    outs aL, aR
endin

; Tiny nervous particles
instr 3
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.015, 1, 1, p3 * 0.2, -3, 0.001, p3 * 0.8, -4, 0

    kWander lfo 0.018, 3.1, 1

    a1 poscil iAmp, iFreq * (1 + kWander)
    a2 poscil iAmp * 0.22, iFreq * 2.73

    aSignal = (a1 + a2) * aEnv

    aL, aR pan2 aSignal, iPan
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; Long-form generative session: 24 hours
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
