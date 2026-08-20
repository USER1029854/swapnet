// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title            Decompiled Contract
/// @author           Jonathan Becker <jonathan@jbecker.dev>
/// @custom:version   heimdall-rs v0.9.2
///
/// @notice           This contract was decompiled using the heimdall-rs decompiler.
///                     It was generated directly by tracing the EVM opcodes from this contract.
///                     As a result, it may not compile or even be valid solidity code.
///                     Despite this, it should be obvious what each function does. Overall
///                     logic should have been preserved throughout decompiling.
///
/// @custom:github    You can find the open-source decompiler here:
///                       https://heimdall.rs

contract DecompiledContract {
    uint256 public constant PANCAKE_V3_POOL_INIT_CODE_HASH = 49261319995587927010630778926378376657704263250649313563538125767892990490594;
    uint256 public constant unresolved_ade52c69 = 115669836688057288971978428345772224980831930297484339931411879238898060099584;
    uint256 public constant OWNER = 894724864332371768232934568590396046754057622714;
    uint256 public constant WETH_TOKEN = 1097077688018008265106216665536940668749033598146;
    uint256 public constant unresolved_9b2fb810 = 115456385562773627507121933337875954052015699771649610559732354713298944393216;
    uint256 public constant unresolved_286117e0 = 548082128733425415811755477653524368126029219268;
    uint256 public constant UNISWAP_V3_POOL_INIT_CODE_HASH = 102814774271675688723325049954498779091328469440286648861889194717372678376276;
    uint256 public constant unresolved_6f94adf7 = 819019874930562209716205676228629769321684280744;
    uint256 public constant unresolved_3750a60d = 115395599522508061429428307120883023012361415493104242916976774162621891870720;
    uint256 public constant PERMIT2 = 180847076211518657644945212059388835;
    uint256 public constant unresolved_0d2c985e = 102814774271675688723325049954498779091328469440286648861889194717372678376276;
    uint256 public constant UNISWAP_V4_POOL_MANAGER = 22154441650658625721468672576359056;
    uint256 public constant unresolved_b995ea27 = 1073778549578307918173071389841047736606978665399;
    uint256 public constant unresolved_9ae38ce4 = 564078065541784035853928725679361089517148498413;
    
    error CustomError_00000000();
    
    /// @custom:selector    0x91dd7346
    /// @custom:signature   Unresolved_91dd7346(uint256 arg0, address arg1, address arg2, uint24 arg3, uint256 arg4, uint256 arg5, address arg6, uint256 arg7, address arg8, uint256 arg9) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint24", "bytes3", "int24"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_91dd7346(uint256 arg0, address arg1, address arg2, uint24 arg3, uint256 arg4, uint256 arg5, address arg6, uint256 arg7, address arg8, uint256 arg9) public payable {
        require(msg.value);
        require((msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x20);
        require(arg0 > 0xffffffffffffffff);
        require(arg0 > 0xffffffffffffffff);
        require(msg.sender - 0x04444c5dc75cb358380d2e3de08a90);
        require(((0x04 + arg0) + 0x20) + (arg0) - ((0x04 + arg0) + 0x20) < 0x0120);
        require((arg0 + 0x20) - (address(arg0 + 0x20)));
        require(((arg0 + 0x20) + 0x20) - (address((arg0 + 0x20) + 0x20)));
        require(((arg0 + 0x20) + 0x40) - (uint24((arg0 + 0x20) + 0x40)));
        require(((arg0 + 0x20) + 0x60) - 11);
        require(((arg0 + 0x20) + 0x80) - ((arg0 + 0x20) + 0x80));
        require(((arg0 + 0x20) + 0xa0) - (address((arg0 + 0x20) + 0xa0)));
        require(((arg0 + 0x20) + 0xe0) - (address((arg0 + 0x20) + 0xe0)));
        require(((arg0 + 0x20) + 0x0100) > 0xffffffffffffffff);
        require(!(((0x04 + arg0) + 0x20) + ((arg0 + 0x20) + 0x0100) + 0x1f) < (((0x04 + arg0) + 0x20) + (arg0)));
        require((arg0 + 0x20) + ((arg0 + 0x20) + 0x0100) > 0xffffffffffffffff);
        require(((var_c + (uint248((0x20 + (0x1f + ((arg0 + 0x20) + ((arg0 + 0x20) + 0x0100)))) + 0x1f))) > 0xffffffffffffffff) | ((var_c + (uint248((0x20 + (0x1f + ((arg0 + 0x20) + ((arg0 + 0x20) + 0x0100)))) + 0x1f))) < var_c));
        uint256 var_c = var_c + (uint248((0x20 + (0x1f + ((arg0 + 0x20) + ((arg0 + 0x20) + 0x0100)))) + 0x1f));
        require((((0x04 + arg0) + 0x20) + ((arg0 + 0x20) + 0x0100) + 0x20) + ((arg0 + 0x20) + ((arg0 + 0x20) + 0x0100)) > (((0x04 + arg0) + 0x20) + (arg0)));
        var_e = msg.data[68:68];
        require((arg0 + 0x20) + 0x80);
        require(address(arg0 + 0x20) - 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2);
        require(!0 < (address((arg0 + 0x20) + 0x20)));
        require(!0 < (address((arg0 + 0x20) + 0x20)));
        require(((var_c + 0xa0) > 0xffffffffffffffff) | ((var_c + 0xa0) < var_c));
        var_c = var_c + 0xa0;
        var_f = 0;
        require(((arg0 + 0x20) + 0xc0) == 0x8000000000000000000000000000000000000000000000000000000000000000);
        require(!0 < (address((arg0 + 0x20) + 0x20)));
        require(((var_c + 0x60) > 0xffffffffffffffff) | ((var_c + 0x60) < var_c));
        var_c = var_c + 0x60;
        uint256 var_o = address(var_c.length);
        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_f3cd914c(var_o); // call
        require(!(0 < (address((arg0 + 0x20) + 0x20))), CustomError_12bacdd3());
        require(11 == 0xffffffffffffffffffffffffffffffff80000000000000000000000000000000, CustomError_12bacdd3());
        require(11 > ((arg0 + 0x20) + 0xc0), CustomError_12bacdd3());
        var_a = 0x12bacdd300000000000000000000000000000000000000000000000000000000;
        require(!11);
        require(!address(0x04444c5dc75cb358380d2e3de08a90).code.length);
        var_o = 0;
        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_a5841194(var_o); // call
        require(0);
        var_o = 0x04444c5dc75cb358380d2e3de08a90;
        (bool success, bytes memory ret0) = address(0).Unresolved_a9059cbb(var_o); // call
        require(!((var_a == 0x01) & (ret0.length > 0x1f) | !ret0.length) & (success));
        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).settle(); // call
        require(!11);
        require(address((arg0 + 0x20) + 0x20));
        require(!address(0x04444c5dc75cb358380d2e3de08a90).code.length);
        var_o = address((arg0 + 0x20) + 0x20);
        var_p = address((arg0 + 0x20) + 0xe0);
        var_q = 11;
        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_0b0d9c09(var_o, var_p, var_q); // call
        require(!address(0x04444c5dc75cb358380d2e3de08a90).code.length);
        var_o = address((arg0 + 0x20) + 0x20);
        var_p = address(this);
        var_q = 11;
        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_0b0d9c09(var_o, var_p, var_q); // call
        require(!address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).{ value: 0.000000000000000017 ether }deposit(); // call
        require(address((arg0 + 0x20) + 0xe0) - address(this), "TRANSFER_FAILED");
        var_o = address((arg0 + 0x20) + 0xe0);
        var_p = 11;
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).transfer(var_o, var_p); // call
        require(!(((var_a == 0x01) & (ret0.length > 0x1f) | !ret0.length) & (success)), "TRANSFER_FAILED");
        require(0x20 > ret0.length);
        require(((var_c + 0x20) > 0xffffffffffffffff) | ((var_c + 0x20) < var_c));
        var_c = var_c + 0x20;
        require(((var_c + 0x20) - var_c) < 0x20);
        require(!address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
        var_o = 11;
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).withdraw(var_o); // call
        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).{ value: 0.000000000000000017 ether }settle(); // call
        require(((var_c + 0) > 0xffffffffffffffff) | ((var_c + 0) < var_c));
        var_c = var_c + 0;
        require(0);
        if (0x20 > ret0.length) {
        }
        require(((var_c + 0x60) > 0xffffffffffffffff) | ((var_c + 0x60) < var_c), CustomError_cd2484d0());
        require(address((arg0 + 0x20) + 0x20) - 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2, CustomError_cd2484d0());
    }
    
    /// @custom:selector    0xfa461e33
    /// @custom:signature   Unresolved_fa461e33(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_fa461e33(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.value);
        require((msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x60);
        require(arg2 > 0xffffffffffffffff);
        require(arg2 > 0xffffffffffffffff);
        require(!(uint24((arg2 + 0x20) >> 0xe0) < 0x23), CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x08, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x22, CustomError_7aff4ee7());
        var_a = 0x7aff4ee700000000000000000000000000000000000000000000000000000000;
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x02, "TRANSFER_FAILED");
        require(0x01 == (address((arg2 + 0x20) >> 0x40) > (((arg2 + 0x20) + 0x18) >> 0x60)), "TRANSFER_FAILED");
        require(msg.sender ^ (address(keccak256(var_h))), "TRANSFER_FAILED");
        require((arg2 + 0x20) < 0xff, "TRANSFER_FAILED");
        require(0x01 == (arg0 > 0), "TRANSFER_FAILED");
        address var_i = msg.sender;
        (bool success, bytes memory ret0) = address((arg2 + 0x20) >> 0x40).Unresolved_a9059cbb(var_i); // call
        require(!(((var_a == 0x01) & (ret0.length > 0x1f) | !ret0.length) & (success)), "TRANSFER_FAILED");
        require((arg2 + 0x20) < 0xfe, "TRANSFER_FROM_FAILED");
        require(0x01 == (arg0 > 0), "TRANSFER_FROM_FAILED");
        var_i = ((arg2 + 0x20) + 0x2f) >> 0x60;
        (bool success, bytes memory ret0) = address((arg2 + 0x20) >> 0x40).Unresolved_23b872dd(var_i); // call
        require(!(((var_a == 0x01) & (ret0.length > 0x1f) | !ret0.length) & (success)), "TRANSFER_FROM_FAILED");
        require(0 < (arg2 + 0x20));
        require(!(((arg2 + 0x20) + 0x2f) + 0x20) < 0x23);
        require(!(((arg2 + 0x20) + 0x2f) + 0x20) == 0x01);
        require(!(((arg2 + 0x20) + 0x2f) + 0x20) == 0x01);
        require(!((arg2 + 0x20) + 0x2f) + 0x60);
        require(((var_l + 0x20) > 0xffffffffffffffff) | ((var_l + 0x20) < var_l));
        uint256 var_l = var_l + 0x20;
        require(!address(((arg2 + 0x20) + 0x2f) + 0x40).code.length);
        var_j = 0;
        (bool success, bytes memory ret0) = address(((arg2 + 0x20) + 0x2f) + 0x40).Unresolved_022c0d9f(var_j); // call
        require(!((((arg2 + 0x20) + 0x2f) + 0x20) < 0x23), CustomError_0429e620());
        require(!(uint24((arg2 + 0x20) >> 0xe0) < 0x23), CustomError_0429e620());
        if (uint24((arg2 + 0x20) >> 0xe0) - 0x06) {
            require(uint24((arg2 + 0x20) >> 0xe0) - 0x06, CustomError_7aff4ee7());
        }
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x1e, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0b, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x1f, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0d, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0e, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x15, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0f, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x19, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x1b, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x20, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x21, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x10, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x11, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x12, CustomError_7aff4ee7());
    }
    
    /// @custom:selector    0x585da628
    /// @custom:signature   Unresolved_585da628(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, bool arg4) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_585da628(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, bool arg4) public view {
        require(msg.value);
        require((msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x40);
        require(arg0 > 0xffffffffffffffff);
        require(arg0 > 0xffffffffffffffff);
        require(arg1 > 0xffffffffffffffff);
        require(arg1 > 0xffffffffffffffff);
        require(msg.sender - 0x6000da47483062a0d734ba3dc7576ce6a0b645c4, CustomError_a5191873());
        require(arg0 > 0x01, CustomError_a5191873());
        require(!arg0);
        require(((var_b + 0xc0) > 0xffffffffffffffff) | ((var_b + 0xc0) < var_b));
        uint256 var_b = var_b + 0xc0;
        require((arg1 + 0x20) + (arg1 + 0x20) < 0x02);
        require(!(arg1 + 0x20) + (arg1 + 0x20));
        require((((arg1 + 0x20) + (arg1 + 0x20) + 0x20) + 0x40) - (bytes1(((arg1 + 0x20) + (arg1 + 0x20) + 0x20) + 0x40)));
        require(bytes1(((arg1 + 0x20) + (arg1 + 0x20) + 0x20) + 0x40), CustomError_fad37ca6());
        require((arg1 + 0x20) + (arg1 + 0x20) > 0xffffffffffffffff, CustomError_71e51ac0());
        require(((var_b + (uint248((0x20 + ((arg1 + 0x20) + (arg1 + 0x20) << 0x05)) + 0x1f))) > 0xffffffffffffffff) | ((var_b + (uint248((0x20 + ((arg1 + 0x20) + (arg1 + 0x20) << 0x05)) + 0x1f))) < var_b), CustomError_71e51ac0());
        require((arg1 + 0x20) + (arg1 + 0x20) > 0xffffffffffffffff, CustomError_71e51ac0());
    }
    
    /// @custom:selector    0x7c734889
    /// @custom:signature   Unresolved_7c734889(uint256 arg0, uint256 arg1, uint256 arg2, bool arg3) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_7c734889(uint256 arg0, uint256 arg1, uint256 arg2, bool arg3) public view {
        require(msg.value);
        require((msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x80);
        require(arg0 > 0xffffffffffffffff);
        require(((msg.data.length - arg0) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x40);
        require(arg1 > 0xffffffffffffffff);
        require(arg1 > 0xffffffffffffffff);
        require(arg2 > 0xffffffffffffffff);
        require(arg2 > 0xffffffffffffffff);
        require(!msg.sender == 0x8f761f127ae9daa245b4203c9cc2cc5285fe25a8);
        require(!msg.sender == 0x8f761f127ae9daa245b4203c9cc2cc5285fe25a8);
        require(!msg.sender == 0x8f761f127ae9daa245b4203c9cc2cc5285fe25a8);
        require(!msg.sender == 0x8f761f127ae9daa245b4203c9cc2cc5285fe25a8);
        require(0 < (arg1));
        require((arg1 + 0x20) - (address(arg1 + 0x20)));
        require(((arg1 + 0x20) + 0x20) - ((arg1 + 0x20) + 0x20));
        require(((arg1 + 0x20) + 0x40) - (bytes1((arg1 + 0x20) + 0x40)));
        require(0 < (arg2));
        require(((var_f + (uint248((((var_f + 0xa0) + (arg2 << 0x05) + 0x20) - var_f) + 0x1f))) > 0xffffffffffffffff) | ((var_f + (uint248((((var_f + 0xa0) + (arg2 << 0x05) + 0x20) - var_f) + 0x1f))) < var_f));
        require(!address(0x6000da47483062a0d734ba3dc7576ce6a0b645c4).code.length);
        require(arg0 + (arg0) > 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x5ecb16cd
    /// @custom:signature   Unresolved_5ecb16cd(uint256 arg0, address arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_5ecb16cd(uint256 arg0, address arg1) public payable returns (uint256) {
        require(msg.value);
        require((msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x20);
        require(arg0 > 0xffffffffffffffff);
        require(arg0 > 0xffffffffffffffff);
        require(msg.sender - 0x9cb8d9bae84830b7f5f11ee5048c04a80b8514ba);
        require(!0 < (arg0));
        require(((arg0 + 0x20) + 0) - (address((arg0 + 0x20) + 0)));
        require(!address((arg0 + 0x20) + 0));
        address var_b = address(this);
        (bool success, bytes memory ret0) = address((arg0 + 0x20) + 0).Unresolved_70a08231(var_b); // staticcall
        require(0 > 0x01, "TRANSFER_FAILED");
        var_b = msg.sender;
        (bool success, bytes memory ret0) = address((arg0 + 0x20) + 0).Unresolved_a9059cbb(var_b); // call
        require(!(((var_d == 0x01) & (ret0.length > 0x1f) | !ret0.length) & (success)), "TRANSFER_FAILED");
        require(0x20 > ret0.length);
        require(((var_f + 0x20) > 0xffffffffffffffff) | ((var_f + 0x20) < var_f));
        uint256 var_f = var_f + 0x20;
        require(((var_f + 0x20) - var_f) < 0x20);
        if (var_f.length > 0x01) {
        }
        (bool success, bytes memory ret0) = address(msg.sender).transfer(address(this).balance);
        return ;
    }
    
    /// @custom:selector    0x23a69e75
    /// @custom:signature   Unresolved_23a69e75(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_23a69e75(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.value);
        require((msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x60);
        require(arg2 > 0xffffffffffffffff);
        require(arg2 > 0xffffffffffffffff);
        require(!(uint24((arg2 + 0x20) >> 0xe0) < 0x23), CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x08, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x22, CustomError_7aff4ee7());
        var_a = 0x7aff4ee700000000000000000000000000000000000000000000000000000000;
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x02, "TRANSFER_FAILED");
        require(0x01 == (address((arg2 + 0x20) >> 0x40) > (((arg2 + 0x20) + 0x18) >> 0x60)), "TRANSFER_FAILED");
        require(msg.sender ^ (address(keccak256(var_h))), "TRANSFER_FAILED");
        require((arg2 + 0x20) < 0xff, "TRANSFER_FAILED");
        require(0x01 == (arg0 > 0), "TRANSFER_FAILED");
        address var_i = msg.sender;
        (bool success, bytes memory ret0) = address((arg2 + 0x20) >> 0x40).Unresolved_a9059cbb(var_i); // call
        require(!(((var_a == 0x01) & (ret0.length > 0x1f) | !ret0.length) & (success)), "TRANSFER_FAILED");
        require((arg2 + 0x20) < 0xfe, "TRANSFER_FROM_FAILED");
        require(0x01 == (arg0 > 0), "TRANSFER_FROM_FAILED");
        var_i = ((arg2 + 0x20) + 0x2f) >> 0x60;
        (bool success, bytes memory ret0) = address((arg2 + 0x20) >> 0x40).Unresolved_23b872dd(var_i); // call
        require(!(((var_a == 0x01) & (ret0.length > 0x1f) | !ret0.length) & (success)), "TRANSFER_FROM_FAILED");
        require(0 < (arg2 + 0x20));
        require(!(((arg2 + 0x20) + 0x2f) + 0x20) < 0x23);
        require(!(((arg2 + 0x20) + 0x2f) + 0x20) == 0x01);
        require(!(((arg2 + 0x20) + 0x2f) + 0x20) == 0x01);
        require(!((arg2 + 0x20) + 0x2f) + 0x60);
        require(((var_l + 0x20) > 0xffffffffffffffff) | ((var_l + 0x20) < var_l));
        uint256 var_l = var_l + 0x20;
        require(!address(((arg2 + 0x20) + 0x2f) + 0x40).code.length);
        var_j = 0;
        (bool success, bytes memory ret0) = address(((arg2 + 0x20) + 0x2f) + 0x40).Unresolved_022c0d9f(var_j); // call
        require(!((((arg2 + 0x20) + 0x2f) + 0x20) < 0x23), CustomError_0429e620());
        require(!(uint24((arg2 + 0x20) >> 0xe0) < 0x23), CustomError_0429e620());
        if (uint24((arg2 + 0x20) >> 0xe0) - 0x06) {
            require(uint24((arg2 + 0x20) >> 0xe0) - 0x06, CustomError_7aff4ee7());
        }
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x1e, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0b, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x1f, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0d, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0e, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x15, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x0f, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x19, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x1b, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x20, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x21, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x10, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x11, CustomError_7aff4ee7());
        require(uint24((arg2 + 0x20) >> 0xe0) - 0x12, CustomError_7aff4ee7());
    }
    
    /// @custom:selector    0x87395540
    /// @custom:signature   Unresolved_87395540(uint256 arg0, uint256 arg1, uint256 arg2, address arg3) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_87395540(uint256 arg0, uint256 arg1, uint256 arg2, address arg3) public pure {
        require((msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc) < 0x80);
        require(arg0 > 0xffffffffffffffff);
        require(arg0 > 0xffffffffffffffff);
        require(arg1 > 0xffffffffffffffff);
        require(arg1 > 0xffffffffffffffff);
        require(arg3 - (address(arg3)));
        require(arg0 < 0x02);
        require(!arg0);
        require(((arg0 + 0x20) + 0x40) - (bytes1((arg0 + 0x20) + 0x40)));
        require(bytes1((arg0 + 0x20) + 0x40), CustomError_fad37ca6());
        require(arg0 > 0xffffffffffffffff, CustomError_71e51ac0());
        require(((var_c + (uint248((0x20 + (arg0 << 0x05)) + 0x1f))) > 0xffffffffffffffff) | ((var_c + (uint248((0x20 + (arg0 << 0x05)) + 0x1f))) < var_c), CustomError_71e51ac0());
        require(arg0 > 0xffffffffffffffff, CustomError_71e51ac0());
    }
}