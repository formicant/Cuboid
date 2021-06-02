  MODULE Stack

; Stores the sp register in memory
  MACRO Stack.store
    ld (Stack.spStorage), sp
  ENDM

; Restores the sp register from memory
  MACRO Stack.restore
    ld sp, (Stack.spStorage)
  ENDM

  ENDMODULE
