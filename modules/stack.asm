  MODULE Stack

spStorage           ; temporary storage for SP register
    word 0          ; when the stack is used for something else

  MACRO Stack.store
    ld (Stack.spStorage), sp
  ENDM

  MACRO Stack.restore
    ld sp, (Stack.spStorage)
  ENDM

  ENDMODULE
