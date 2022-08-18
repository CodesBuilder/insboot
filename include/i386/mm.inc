%ifndef __ARCH_MM_INC__
%define __ARCH_MM_INC__

%define SEG_R(addr) ((addr)>>4)
%define OFF_R(addr) ((addr)&0x0000f)

%define BOOTSEC_BASE 0x07c00
%define CONNECTOR_BASE 0x10000
%define CONNECTOR_BASE 0x10000

struc e820_entry_t
    base_low resd 1
    base_high resd 1
    len_low resd 1
    len_high resd 1
    type resd 1
endstruc

%endif