  MODULE Tile       ; Operations with 8×4 px tiles

  ALIGN 256
; Screen addresses of each tile row (0..47)
; length: 96
tileRowAddrTable
    word #4000, #4400, #4020, #4420, #4040, #4440, #4060, #4460
    word #4080, #4480, #40A0, #44A0, #40C0, #44C0, #40E0, #44E0
    word #4800, #4C00, #4820, #4C20, #4840, #4C40, #4860, #4C60
    word #4880, #4C80, #48A0, #4CA0, #48C0, #4CC0, #48E0, #4CE0
    word #5000, #5400, #5020, #5420, #5040, #5440, #5060, #5460
    word #5080, #5480, #50A0, #54A0, #50C0, #54C0, #50E0, #54E0


  ENDMODULE
