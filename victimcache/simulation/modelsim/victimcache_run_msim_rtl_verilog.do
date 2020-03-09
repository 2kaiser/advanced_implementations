transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_tag_store.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_plru_logic.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_plru_array.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_metadata_array.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_data_array.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_metadata_store.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_data_store.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/vc_control.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/stores.sv}
vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hdl {/home/skcheun2/Desktop/victimcache/hdl/victimcache.sv}

vlog -sv -work work +incdir+/home/skcheun2/Desktop/victimcache/hvl {/home/skcheun2/Desktop/victimcache/hvl/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L arriaii_hssi_ver -L arriaii_pcie_hip_ver -L arriaii_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
