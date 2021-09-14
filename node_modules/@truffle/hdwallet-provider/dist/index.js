"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
require("source-map-support/register");
const bip39 = __importStar(require("bip39"));
const EthUtil = __importStar(require("ethereumjs-util"));
const ethereumjs_wallet_1 = __importDefault(require("ethereumjs-wallet"));
const hdkey_1 = __importDefault(require("ethereumjs-wallet/hdkey"));
const ethereumjs_tx_1 = __importDefault(require("ethereumjs-tx"));
// @ts-ignore
const web3_provider_engine_1 = __importDefault(require("@trufflesuite/web3-provider-engine"));
const filters_1 = __importDefault(require("@trufflesuite/web3-provider-engine/subproviders/filters"));
const nonce_tracker_1 = __importDefault(require("@trufflesuite/web3-provider-engine/subproviders/nonce-tracker"));
const hooked_wallet_1 = __importDefault(require("@trufflesuite/web3-provider-engine/subproviders/hooked-wallet"));
const provider_1 = __importDefault(require("@trufflesuite/web3-provider-engine/subproviders/provider"));
const url_1 = __importDefault(require("url"));
const web3_1 = __importDefault(require("web3"));
// Important: do not use debug module. Reason: https://github.com/trufflesuite/truffle/issues/2374#issuecomment-536109086
// This line shares nonce state across multiple provider instances. Necessary
// because within truffle the wallet is repeatedly newed if it's declared in the config within a
// function, resetting nonce from tx to tx. An instance can opt out
// of this behavior by passing `shareNonce=false` to the constructor.
// See issue #65 for more
const singletonNonceSubProvider = new nonce_tracker_1.default();
class HDWalletProvider {
    constructor(mnemonic, provider, addressIndex = 0, numAddresses = 10, shareNonce = true, walletHdpath = `m/44'/60'/0'/0/`) {
        this.walletHdpath = walletHdpath;
        this.wallets = {};
        this.addresses = [];
        this.engine = new web3_provider_engine_1.default();
        if (!HDWalletProvider.isValidProvider(provider)) {
            throw new Error([
                `Malformed provider URL: '${provider}'`,
                "Please specify a correct URL, using the http, https, ws, or wss protocol.",
                ""
            ].join("\n"));
        }
        // private helper to normalize given mnemonic
        const normalizePrivateKeys = (mnemonic) => {
            if (Array.isArray(mnemonic))
                return mnemonic;
            else if (mnemonic && !mnemonic.includes(" "))
                return [mnemonic];
            // if truthy, but no spaces in mnemonic
            else
                return false; // neither an array nor valid value passed;
        };
        // private helper to check if given mnemonic uses BIP39 passphrase protection
        const checkBIP39Mnemonic = (mnemonic) => {
            this.hdwallet = hdkey_1.default.fromMasterSeed(bip39.mnemonicToSeed(mnemonic));
            if (!bip39.validateMnemonic(mnemonic)) {
                throw new Error("Mnemonic invalid or undefined");
            }
            // crank the addresses out
            for (let i = addressIndex; i < addressIndex + numAddresses; i++) {
                const wallet = this.hdwallet
                    .derivePath(this.walletHdpath + i)
                    .getWallet();
                const addr = `0x${wallet.getAddress().toString("hex")}`;
                this.addresses.push(addr);
                this.wallets[addr] = wallet;
            }
        };
        // private helper leveraging ethUtils to populate wallets/addresses
        const ethUtilValidation = (privateKeys) => {
            // crank the addresses out
            for (let i = addressIndex; i < privateKeys.length; i++) {
                const privateKey = Buffer.from(privateKeys[i].replace("0x", ""), "hex");
                if (EthUtil.isValidPrivate(privateKey)) {
                    const wallet = ethereumjs_wallet_1.default.fromPrivateKey(privateKey);
                    const address = wallet.getAddressString();
                    this.addresses.push(address);
                    this.wallets[address] = wallet;
                }
            }
        };
        const privateKeys = normalizePrivateKeys(mnemonic);
        if (!privateKeys)
            checkBIP39Mnemonic(mnemonic);
        else
            ethUtilValidation(privateKeys);
        const tmp_accounts = this.addresses;
        const tmp_wallets = this.wallets;
        this.engine.addProvider(new hooked_wallet_1.default({
            getAccounts(cb) {
                cb(null, tmp_accounts);
            },
            getPrivateKey(address, cb) {
                if (!tmp_wallets[address]) {
                    return cb("Account not found");
                }
                else {
                    cb(null, tmp_wallets[address].getPrivateKey().toString("hex"));
                }
            },
            signTransaction(txParams, cb) {
                let pkey;
                const from = txParams.from.toLowerCase();
                if (tmp_wallets[from]) {
                    pkey = tmp_wallets[from].getPrivateKey();
                }
                else {
                    cb("Account not found");
                }
                const tx = new ethereumjs_tx_1.default(txParams);
                tx.sign(pkey);
                const rawTx = `0x${tx.serialize().toString("hex")}`;
                cb(null, rawTx);
            },
            signMessage({ data, from }, cb) {
                const dataIfExists = data;
                if (!dataIfExists) {
                    cb("No data to sign");
                }
                if (!tmp_wallets[from]) {
                    cb("Account not found");
                }
                let pkey = tmp_wallets[from].getPrivateKey();
                const dataBuff = EthUtil.toBuffer(dataIfExists);
                const msgHashBuff = EthUtil.hashPersonalMessage(dataBuff);
                const sig = EthUtil.ecsign(msgHashBuff, pkey);
                const rpcSig = EthUtil.toRpcSig(sig.v, sig.r, sig.s);
                cb(null, rpcSig);
            },
            signPersonalMessage(...args) {
                this.signMessage(...args);
            }
        }));
        !shareNonce
            ? this.engine.addProvider(new nonce_tracker_1.default())
            : this.engine.addProvider(singletonNonceSubProvider);
        this.engine.addProvider(new filters_1.default());
        if (typeof provider === "string") {
            // shim Web3 to give it expected sendAsync method. Needed if web3-engine-provider upgraded!
            // Web3.providers.HttpProvider.prototype.sendAsync =
            // Web3.providers.HttpProvider.prototype.send;
            let subProvider;
            const providerProtocol = (url_1.default.parse(provider).protocol || "http:").toLowerCase();
            switch (providerProtocol) {
                case "ws:":
                case "wss:":
                    subProvider = new web3_1.default.providers.WebsocketProvider(provider);
                    break;
                default:
                    // @ts-ignore: Incorrect typings in @types/web3
                    subProvider = new web3_1.default.providers.HttpProvider(provider, {
                        keepAlive: false
                    });
            }
            this.engine.addProvider(new provider_1.default(subProvider));
        }
        else {
            this.engine.addProvider(new provider_1.default(provider));
        }
        // Required by the provider engine.
        this.engine.start((err) => {
            if (err)
                throw err;
        });
    }
    send(payload, callback) {
        return this.engine.send.call(this.engine, payload, callback);
    }
    sendAsync(payload, callback) {
        this.engine.sendAsync.call(this.engine, payload, callback);
    }
    getAddress(idx) {
        if (!idx) {
            return this.addresses[0];
        }
        else {
            return this.addresses[idx];
        }
    }
    getAddresses() {
        return this.addresses;
    }
    static isValidProvider(provider) {
        const validProtocols = ["http:", "https:", "ws:", "wss:"];
        if (typeof provider === "string") {
            const url = url_1.default.parse(provider.toLowerCase());
            return !!(validProtocols.includes(url.protocol || "") && url.slashes);
        }
        return true;
    }
}
module.exports = HDWalletProvider;
//# sourceMappingURL=index.js.map