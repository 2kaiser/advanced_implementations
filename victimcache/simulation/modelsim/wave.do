onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate -expand -group {dut sigs} -group {from l1 cache} -radix hexadecimal /tb/mem_address
add wave -noupdate -expand -group {dut sigs} -group {from l1 cache} -radix hexadecimal /tb/vc_write
add wave -noupdate -expand -group {dut sigs} -group {from l1 cache} -radix hexadecimal /tb/vc_read
add wave -noupdate -expand -group {dut sigs} -group {from l1 cache} -radix hexadecimal /tb/mem_wdata
add wave -noupdate -expand -group {dut sigs} -group {from l1 cache} -radix hexadecimal /tb/is_mem_wdata_dirty
add wave -noupdate -expand -group {dut sigs} -group {to l1 cache} -radix hexadecimal /tb/rdata_exists
add wave -noupdate -expand -group {dut sigs} -group {to l1 cache} -radix hexadecimal /tb/vc_vcmem_rdata256
add wave -noupdate -expand -group {stores sigs} -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_tag_store_datain
add wave -noupdate -expand -group {stores sigs} -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_valid_datain
add wave -noupdate -expand -group {stores sigs} -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_dirty_datain
add wave -noupdate -expand -group {stores sigs} -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_plru_datain
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_tag_store_ld_mask
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_datastore_datain
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_datastore_ld_mask
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_valid_ld
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_dirty_ld
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_tag_cmp
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_datastore_read
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_plru_ld
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_valid_read
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_dirty_read
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_plru_read
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_tag_write
add wave -noupdate -expand -group {stores sigs} -group {dataout and cacheline select} -radix hexadecimal /tb/dut/STORES/vc_valid_dataout
add wave -noupdate -expand -group {stores sigs} -group {dataout and cacheline select} -radix hexadecimal /tb/dut/STORES/vc_dirty_dataout
add wave -noupdate -expand -group {stores sigs} -group {dataout and cacheline select} -radix hexadecimal /tb/dut/STORES/vc_plru_dataout
add wave -noupdate -expand -group {stores sigs} -group {dataout and cacheline select} -radix hexadecimal /tb/dut/STORES/vc_datamux_sel
add wave -noupdate -expand -group {stores sigs} -radix hexadecimal /tb/dut/STORES/vc_vcmem_rdata256
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline8
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline1
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline2
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline3
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline4
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline5
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline6
add wave -noupdate -expand -group {stores sigs} -group {cacheline values} -radix hexadecimal /tb/dut/STORES/cacheline7
add wave -noupdate -expand -group vc_control -radix hexadecimal /tb/dut/VCC/shift_amt
add wave -noupdate -expand -group vc_control -expand -group vc_control -radix hexadecimal /tb/dut/VCC/vc_read
add wave -noupdate -expand -group vc_control -expand -group vc_control -radix hexadecimal /tb/dut/VCC/vc_write
add wave -noupdate -expand -group vc_control -expand -group vc_control -radix hexadecimal /tb/dut/VCC/is_mem_wdata_dirty
add wave -noupdate -expand -group vc_control -expand -group vc_control -radix hexadecimal /tb/dut/VCC/mem_address
add wave -noupdate -expand -group vc_control -expand -group vc_control -radix hexadecimal /tb/dut/VCC/mem_wdata
add wave -noupdate -expand -group vc_control -group {datastore sigs} -radix hexadecimal /tb/dut/VCC/vc_datamux_sel
add wave -noupdate -expand -group vc_control -group {datastore sigs} -radix hexadecimal /tb/dut/VCC/vc_datastore_datain
add wave -noupdate -expand -group vc_control -group {datastore sigs} -radix hexadecimal /tb/dut/VCC/vc_datastore_ld_mask
add wave -noupdate -expand -group vc_control -group {datastore sigs} -radix hexadecimal /tb/dut/VCC/vc_datastore_read
add wave -noupdate -expand -group vc_control -group {tag sigs} -radix hexadecimal /tb/dut/VCC/vc_tag_store_datain
add wave -noupdate -expand -group vc_control -group {tag sigs} -radix hexadecimal /tb/dut/VCC/vc_tag_store_ld_mask
add wave -noupdate -expand -group vc_control -group {tag sigs} -radix hexadecimal /tb/dut/VCC/vc_tag_cmp
add wave -noupdate -expand -group vc_control -group {tag sigs} -radix hexadecimal /tb/dut/VCC/vc_tag_write
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_valid_dataout
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_dirty_dataout
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_plru_dataout
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_valid_ld
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_dirty_ld
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_valid_datain
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} /tb/dut/VCC/vc_valid_mask
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_dirty_datain
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_valid_read
add wave -noupdate -expand -group vc_control -expand -group {metadata sigs} -radix hexadecimal /tb/dut/VCC/vc_dirty_read
add wave -noupdate -expand -group vc_control -radix hexadecimal /tb/dut/VCC/rdata_exists
add wave -noupdate -expand -group vc_control -radix hexadecimal /tb/dut/VCC/state
add wave -noupdate -expand -group vc_control -radix hexadecimal /tb/dut/VCC/next_states
add wave -noupdate -expand -group vc_control -group {plru sigs} -radix hexadecimal /tb/dut/VCC/acc_idx
add wave -noupdate -expand -group vc_control -group {plru sigs} -radix hexadecimal /tb/dut/VCC/vc_plru_read
add wave -noupdate -expand -group vc_control -group {plru sigs} -radix hexadecimal /tb/dut/VCC/vc_plru_datain
add wave -noupdate -expand -group vc_control -group {plru sigs} -radix hexadecimal /tb/dut/VCC/vc_plru_ld
add wave -noupdate -expand -group vc_control -group {plru sigs} -radix hexadecimal /tb/dut/VCC/lru_idx
add wave -noupdate -expand -group vc_control -group {plru sigs} -radix hexadecimal /tb/dut/VCC/acc_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25379 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 380
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {54600 ps}
