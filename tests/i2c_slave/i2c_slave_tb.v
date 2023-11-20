module i2c_master(
        SDA,
        SCL,
        RST
    );
    input logic RST;
    inout logic SCL;
    inout logic SDA;
    parameter i2c_delay = 5;

    reg error_nack;
    reg scl_en;
    reg sda_out;
    wire sda_in;

    assign SDA = sda_out ? 1'bz : 1'b0;
    assign sda_in = SDA;
    assign SCL = scl_en ? 1'bz : 1'b0;

    pullup(SDA);
    pullup(SCL);

    initial
    begin
        error_nack = 1'b0;
    end

    always@(posedge RST)
    begin
        if(RST)
        begin
            sda_out<=1'b1;
            scl_en<=1'b1;
        end
        else
        begin
            sda_out<=sda_out;
            scl_en<=scl_en;
        end
    end

    //---------------------------------------------------
    //--------------------base functions-----------------
    //---------------------------------------------------
    task start_bit();
        $display("%0t i2c.master start_bit begin", $time());
        sda_out = 1'b0;
        #i2c_delay;
        scl_en = 1'b0;
        #i2c_delay;
        $display("%0t i2c.master start_bit end", $time());
    endtask

    task stop_bit();
        $display("%0t i2c.master stop_bit begin", $time());
        sda_out = 1'b0;
        #i2c_delay;
        scl_en = 'b1;
        #i2c_delay;
        sda_out = 1'b1;
        #i2c_delay;
        $display("%0t i2c.master stop_bit end", $time());
    endtask

    task send_byte(input logic [7:0] data);
        integer i; 
        $display("%0t i2c.master send_byte begin", $time());
        $display("%0t i2c.master send_byte data = %0b (0x%0x)", $time(), data, data);
        #i2c_delay;
        for(i = 0; i <= 7; i = i+1)
        begin
            sda_out = data[7-i];
            #i2c_delay;
            scl_en = 1'b1;
            #(i2c_delay*2);
            scl_en = 1'b0;
            #i2c_delay;
        end
        $display("%0t i2c.master send_byte end", $time());
    endtask

    task detect_ack();
        $display("%0t i2c.master detect_ack begin", $time());
        #i2c_delay;
        scl_en = 1'b1;
        if(sda_in == 1'b0)
        begin
            $display("%0t i2c.master detect_ack ACK detected", $time());
        end
        else
        begin
            $display("%0t i2c.master detect_ack NACK detected", $time());
            error_nack = 1'b1;
        end
        #(i2c_delay * 2);
        scl_en = 1'b0;
        $display("%0t i2c.master detect_ack ACK/NACK %0b", $time(), error_nack);
        $display("%0t i2c.master detect_ack end", $time());
    endtask

    task restart();
        $display("%0t i2c.master restart begin", $time());
        scl_en = 1'b0;
        #i2c_delay;
        sda_out = 1'b1;
        #i2c_delay;
        scl_en = 1'b1;
        #i2c_delay;
        start_bit();
        $display("%0t i2c.master restart end", $time());
    endtask

    task receive_byte(output logic [7:0] data);
        integer i;
        $display("%0t i2c.master receive_byte begin", $time());
        #i2c_delay;
        for(i = 0; i<= 7; i = i+1)
        begin
            #i2c_delay;
            scl_en=1'b1;
            data[7-i]=sda_in;
            #i2c_delay;
            scl_en=1'b0;
        end
        //gen ack or gen stop; 
        $display("%0t i2c.master receive_byte data = %0b (0x%0x)", $time(), data, data);
        $display("%0t i2c.master receive_byte begin", $time());
    endtask

    task gen_scl(input int cycles);
        integer i;
        $display("%0t i2c.master gen_scl begin", $time());
        $display("%0t i2c.master gen_scl SCL count %0d", $time(), cycles);
        for(i=0; i < cycles; i = i+1)
        begin
            #i2c_delay;
            scl_en=1'b1;
            #i2c_delay;
            scl_en=1'b0;
        end
        #i2c_delay;
        scl_en=1'b1;
        $display("%0t i2c.master gen_scl end", $time());
    endtask

    task gen_ack();
        $display("%0t i2c.master gen_ack begin", $time());
        #i2c_delay;
        scl_en = 1'b0;
        #i2c_delay;
        sda_out = 1'b0;
        #i2c_delay;
        scl_en = 1'b1;
        #i2c_delay;
        scl_en = 1'b0;
        #i2c_delay;
        sda_out = 1'b1;
        $display("%0t i2c.master gen_ack end", $time());
    endtask

    //-----------------------------------------------------
    //-----------------------functions---------------------
    //-----------------------------------------------------
    task i2c_write(
        input logic [6:0] addr,
        input logic [7:0] index,
        input int N,
        input logic [7:0] data[$]);
        integer i, j;

        $display("%0t i2c.master i2c_write begin", $time());

        start_bit();
        send_byte({addr, 1'b0}); //write
        detect_ack();
        send_byte(index);
        detect_ack();
        //for(i = 0; i < N; i = i+1)
        //begin
        //    send_byte(data[i]);
        //    detect_ack();
        //end
        stop_bit();
        //gen_scl(1); //for detect the stop to idle
        //$display("%0t write Bytes=%d to Addr=%h", $time(), N, addr);
        //for(j = 0; j < 8; j++)
        //begin
        //    $display("%0t index=%d, data=%h", $time(), index+j, data[j]);
        //end
        $display("%0t i2c.master i2c_write end\n\n", $time());
    endtask

    //task i2c_read(input logic [6:0] addr,input logic [7:0] index,input int N,output logic [7:0] data[$]);
    //    integer i, j;
    //    start_bit();
    //    send_byte({addr,1'b0});//write
    //    detect_ack();
    //    send_byte(index);
    //    detect_ack();

    //    restart();
    //    send_byte({addr,1'b1});//read
    //    detect_ack();
    //    for(i=0;i<N;i=i+1)
    //    begin
    //        receive_byte(data[i]);
    //        if(i==N-1)//last data
    //        begin
    //            gen_scl(3);//no ack to jump to idle
    //            stop_bit();
    //        end
    //        else
    //            gen_ack();
    //    end
    //    $display("read Bytes=%d to Addr=%h",N,addr);
    //    for(j=0;j<8;j++)
    //    begin
    //        $display("index=%d,data=%h",index+j,data[j]);
    //    end
    //endtask
endmodule

// -----------------------------------------------

module tb_i2c();

    reg clk;
    wire SDA;
    wire SCL;
    reg RST;
    reg [7:0] LEDG;
    reg [17:0] LEDR;
    reg SW_1;

    reg [7:0] cmd;
    reg [7:0] data_recv;
    reg [7:0] data[$];
    reg [7:0] recv[$];

    parameter [6:0] SLAVE_ADDR = 7'h55;
    parameter [7:0] index = 8'h01;
    parameter READ = 1'b1, WRITE = 1'b0;

    i2c_slave u_i2c_slave(
        .clk(clk),
        .SCL(SCL),
        .SDA(SDA),
        .RST(RST),
        .LEDG(LEDG),
        .LEDR(LEDR),
        .SW_1(SW_1)
        );
    i2c_master u_i2c_master(
        .SCL(SCL),
        .SDA(SDA),
        .RST(RST)
        );

    always
    begin
        #2 clk = ~clk;
    end

    initial
    begin
        clk = 1'b0;
        RST = 1'b0;
        #2;
        RST = 1'b1;
        #5;
        RST = 1'b0;
        #5;

        u_i2c_master.i2c_write(SLAVE_ADDR, index, 1, data);
//  data={8'h5a};
    //  u_i2c.reg_01<=8'h5a;//to force the data
//  u_i2c_master.i2c_read(slave_addr,index,1,recv);


//two test
    /*  data={8'h5a,8'ha5};
     u_i2c_master.i2c_write(slave_addr,index,2,data);

     u_i2c.reg_00<=8'ha5;//to force the data
     u_i2c.reg_01<=8'h5a;//to force the data
     u_i2c.reg_02<=8'haa;//to force the data
     u_i2c.reg_03<=8'h55;//to force the data
     u_i2c_master.i2c_read(slave_addr,index,2,recv);*/

     #10;
     $display("%0t TB: done", $time());
     $finish();;
    end


//-----------------------initial test----------------------
//initial
//begin

//  #12;
/*  u_i2c_master.start_bit();
 cmd={slave_addr,write};
 u_i2c_master.send_byte(cmd);
 u_i2c_master.detect_ack();
 u_i2c_master.send_byte(index);
 u_i2c_master.detect_ack();
 u_i2c_master.send_byte(8'ha5);//data=8'ha5
 u_i2c_master.detect_ack();
 u_i2c_master.stop_bit();*/



/*  u_i2c.reg_03<=8'h5a;//to force the data
 u_i2c_master.start_bit();
 cmd={slave_addr,write};
 u_i2c_master.send_byte(cmd);
 u_i2c_master.detect_ack();
 u_i2c_master.send_byte(index);
 u_i2c_master.detect_ack();

 u_i2c_master.restart();
 cmd={slave_addr,read};
 u_i2c_master.send_byte(cmd);
 u_i2c_master.detect_ack();
 u_i2c_master.receive_byte(data_recv);

 u_i2c_master.gen_ack();//for continue to read

 //u_i2c_master.gen_scl(3);//for stop to read
 //u_i2c_master.stop_bit();
 */
//end
//-----------------------initial test----------------------


//-----------------------function test---------------------
//initial
//begin
//  #12;
//one test
/*  data={8'h5a};
 u_i2c_master.i2c_write(slave_addr,index,1,data);

 u_i2c.reg_03<=8'h5a;//to force the data
 u_i2c_master.i2c_read(slave_addr,index,1,recv);
 */

//two test
/*  data={8'h5a,8'ha5};
 u_i2c_master.i2c_write(slave_addr,index,2,data);

 u_i2c.reg_00<=8'ha5;//to force the data
 u_i2c.reg_01<=8'h5a;//to force the data
 u_i2c.reg_02<=8'haa;//to force the data
 u_i2c.reg_03<=8'h55;//to force the data
 u_i2c_master.i2c_read(slave_addr,index,2,recv);
 */
//end
//------------------------function test---------------------

endmodule
