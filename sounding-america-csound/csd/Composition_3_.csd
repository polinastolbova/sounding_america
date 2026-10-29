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
; Fluid electronic generative soundscape
; ========================================================

; Deep liquid harmonic current
instr 1
    kFlow lfo 1, 0.023, 1
    kDrift lfo 1, 0.012, 1
    kPulse lfo 1, 0.07, 1

    kRoot = 46 * (1 + 0.018 * kDrift)
    kCut = 850 + 900 * (kFlow + 1)

    a1 poscil 0.085, kRoot
    a2 poscil 0.038, kRoot * 1.503
    a3 poscil 0.022, kRoot * 2.017
    a4 poscil 0.014, kRoot * 3.98

    aBed = a1 + a2 + a3 + a4
    aBed tone aBed, kCut

    aEnv linen 1, 12, p3, 14
    aOut = aBed * aEnv * (0.8 + 0.2 * kPulse)

    aL, aR pan2 aOut, 0.5 + 0.2 * kDrift
    outs aL, aR

    ; Liquid drops: changing density and pitch
    kDensity lfo 1, 0.12, 1
    kDensity = 2.4 + 1.7 * (kDensity + 1)
    kTrig metro kDensity

    if kTrig == 1 then
        kStep random 0, 16
        kFreq = 130.81 * (2 ^ (int(kStep) / 12))
        kDur random 0.18, 1.5
        kAmp random 0.025, 0.07
        kPan random 0.03, 0.97
        kMod random 0.01, 0.08

        event "i", 2, 0, kDur, kFreq, kAmp, kPan, kMod
    endif

    ; Longer frequency streams
    kStream metro 0.12
    if kStream == 1 then
        kFreq random 180, 520
        kDur random 2.0, 5.0
        kAmp random 0.012, 0.03
        kPan random 0.05, 0.95
        event "i", 3, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; FM-like droplets
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6
    iModDepth = p7

    aEnv transeg 0, 0.025, 1, 1, p3 * 0.35, -2, 0.001, p3 * 0.615, -3, 0

    kMod lfo iModDepth, 2.3, 1
    kWobble lfo 0.008, 0.37, 1

    aMod poscil iFreq * iModDepth, iFreq * (1.4 + kWobble)
    aCarrier poscil iAmp, iFreq + aMod
    aHarm poscil iAmp * 0.25, iFreq * 2.73

    aDrop = (aCarrier + aHarm) * aEnv

    kPan lfo 0.22, 0.18, 1
    aL, aR pan2 aDrop, limit(iPan + kPan, 0.02, 0.98)
    outs aL, aR
endin

; Slow, sliding electronic streams
instr 3
    iFreq = p4
    iAmp = p5
    iPan = p6

    kSlide lfo 1, 0.09, 1
    kVibrato lfo 0.004, 0.13, 1

    kFreq = iFreq * (1 + 0.06 * kSlide + kVibrato)

    aEnv transeg 0, 0.6, 1, 1, p3 - 1.2, -2, 0.001, 0.6, -3, 0

    a1 poscil iAmp, kFreq
    a2 poscil iAmp * 0.32, kFreq * 1.506
    a3 poscil iAmp * 0.12, kFreq * 2.99

    aStream = (a1 + a2 + a3) * aEnv

    kPan lfo 0.28, 0.07, 1
    aL, aR pan2 aStream, limit(iPan + kPan, 0.02, 0.98)
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; Long-form generative session: 24 hours
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
