defmodule Stellar.Types.Transaction do
  alias XDR.Type.{
    FixedOpaque,
    Enum,
    Union,
    VariableOpaque,
    Void,
    Int,
    Uint,
    HyperInt,
    HyperUint,
    VariableArray,
    Uint
  }

  alias Stellar.Types.{SignatureHint, Signature, PublicKey, Hash}

  alias Stellar.Types.LedgerEntries.{
    Asset,
    Price,
    String32,
    Signer,
    AssetCode4,
    AssetCode12,
    String64,
    DataValue,
    Ext
  }

  defmodule DecoratedSignature do
    use XDR.Type.Struct,
      spec: [
        hint: SignatureHint,
        signature: Signature
      ]
  end

  defmodule OperationType do
    use Enum,
      spec: [
        CREATE_ACCOUNT: 0,
        PAYMENT: 1,
        PATH_PAYMENT: 2,
        MANAGE_OFFER: 3,
        CREATE_PASSIVE_OFFER: 4,
        SET_OPTIONS: 5,
        CHANGE_TRUST: 6,
        ALLOW_TRUST: 7,
        ACCOUNT_MERGE: 8,
        INFLATION: 9,
        MANAGE_DATA: 10
      ]
  end

  defmodule CreateAccountOp do
    use XDR.Type.Struct,
      spec: [
        destination: PublicKey,
        startingBalance: HyperInt
      ]
  end

  defmodule PaymentOp do
    use XDR.Type.Struct,
      spec: [
        destination: PublicKey,
        asset: Asset,
        amount: HyperInt
      ]
  end

  defmodule PathPaymentOp do
    use XDR.Type.Struct,
      spec: [
        sendAsset: Asset,
        sendMax: HyperInt,
        destination: PublicKey,
        destinationAsset: Asset,
        destinationAmount: HyperInt,
        path: AssetPaths
      ]

    defmodule AssetPaths do
      use VariableArray, spec: [max_len: 5, type: Asset]
    end
  end

  defmodule ManageOfferOp do
    use XDR.Type.Struct,
      spec: [
        selling: Asset,
        buying: Asset,
        amount: HyperInt,
        price: Price,
        offerID: HyperUint
      ]
  end

  defmodule CreatePassiveOfferOp do
    use XDR.Type.Struct,
      spec: [
        selling: Asset,
        buying: Asset,
        amount: HyperInt,
        price: Price
      ]
  end

  defmodule SetOptionsOp do
    use XDR.Type.Struct,
      spec: [
        inflationDest: PublicKey,
        clearFlags: Uint,
        setFlags: Uint,
        masterWeight: Uint,
        lowThreshold: Uint,
        medThreshold: Uint,
        highThreshold: Uint,
        homeDomain: String32,
        signer: Signer
      ]
  end

  defmodule ChangeTrustOp do
    use XDR.Type.Struct,
      spec: [
        line: Asset,
        limit: HyperInt
      ]
  end

  defmodule AllowTrustOp do
    use XDR.Type.Struct,
      spec: [
        trustor: PublicKey,
        asset: Asset
      ]

    defmodule Asset do
      use Union,
        spec: [
          switch: AssetType,
          cases: [
            {1, AssetCode4},
            {2, AssetCode12}
          ]
        ]
    end
  end

  defmodule ManageDataOp do
    use XDR.Type.Struct,
      spec: [
        dataName: String64,
        dataValue: DataValue
      ]
  end

  defmodule Operation do
    use XDR.Type.Struct,
      spec: [
        sourceAccount: PublicKey,
        body: OperationUnion
      ]

    defmodule OperationUnion do
      use Union,
        spec: [
          switch: OperationType,
          cases: [
            {0, CreateAccountOp},
            {1, PaymentOp},
            {2, PathPaymentOp},
            {3, ManageOfferOp},
            {4, CreatePassiveOfferOp},
            {5, SetOptionsOp},
            {6, ChangeTrustOp},
            {7, AllowTrustOp},
            {8, PublicKey},
            {9, Void},
            {10, ManageDataOp}
          ]
        ]
    end
  end

  defmodule MemoType do
    use Enum,
      spec: [
        MEMO_NONE: 0,
        MEMO_TEXT: 1,
        MEMO_ID: 2,
        MEMO_HASH: 3,
        MEMO_RETURN: 4
      ]
  end

  defmodule Text do
    use VariableArray, spec: [max_len: 28, type: XDR.Type.String]
  end

  defmodule Memo do
    use Union,
      spec: [
        switch: MemoType,
        cases: [
          {0, Void},
          {1, Text},
          {2, HyperUint},
          {3, Hash},
          {4, Hash}
        ]
      ]
  end

  defmodule TimeBounds do
    use XDR.Type.Struct,
      spec: [
        minTime: HyperUint,
        maxTime: HyperUint
      ]
  end

  defmodule Transaction do
    use XDR.Type.Struct,
      spec: [
        sourceAccount: PublicKey,
        fee: Int,
        seqNum: HyperUint,
        timeBounds: TimeBounds,
        memo: Memo,
        operations: Operations,
        ext: Ext
      ]

    defmodule Operations do
      use VariableArray, spec: [max_len: 100, type: Operation]
    end
  end

  defmodule TransactionSignaturePayload do
    use XDR.Type.Struct,
      spec: [
        networkId: Hash,
        taggedTransaction: TaggedTransaction
      ]

    defmodule TaggedTransaction do
      use Union,
        spec: [
          switch: MemoType,
          cases: [
            {0, Transaction}
          ]
        ]
    end
  end

  defmodule TransactionEnvelope do
    use XDR.Type.Struct,
      spec: [
        tx: Transaction,
        signatures: DecoratedSignatures
      ]

    defmodule DecoratedSignatures do
      use VariableArray, spec: [max_len: 20, type: DecoratedSignature]
    end
  end

  defmodule ClaimOfferAtom do
    use XDR.Type.Struct,
      spec: [
        sellerID: PublicKey,
        offerID: HyperUint,
        assetSold: Asset,
        amountSold: HyperInt,
        assetBought: Asset,
        amountBought: HyperInt
      ]
  end

  #  defmodule CreateAccountResultCode do
  #    use Enum,
  #      spec: [
  #        CREATE_ACCOUNT_SUCCESS: 0,
  #        CREATE_ACCOUNT_MALFORMED: -1,
  #        CREATE_ACCOUNT_UNDERFUNDED: -2,
  #        CREATE_ACCOUNT_LOW_RESERVE: -3,
  #        CREATE_ACCOUNT_ALREADY_EXIST: -4
  #      ]
  #  end
  #
  #  defmodule CreateAccountResult do
  #    use Union,
  #      spec: [
  #        switch: CreateAccountResultCode,
  #        cases: [
  #          {0, VOID}
  #        ]
  #      ]
  #  end

  #  defmodule PaymentResultCode do
  #    use Enum,
  #      spec: [
  #        PAYMENT_SUCCESS: 0,
  #        PAYMENT_MALFORMED: -1,
  #        PAYMENT_UNDERFUNDED: -2,
  #        PAYMENT_SRC_NO_TRUST: -3,
  #        PAYMENT_SRC_NOT_AUTHORIZED: -4,
  #        PAYMENT_NO_DESTINATION: -5,
  #        PAYMENT_NO_TRUST: -6,
  #        PAYMENT_NOT_AUTHORIZED: -7,
  #        PAYMENT_LINE_FULL: -8,
  #        PAYMENT_NO_ISSUER: -9
  #      ]
  #  end
  #
  #  defmodule PaymentResult do
  #    use Union,
  #      spec: [
  #        switch: PaymentResultCode,
  #        cases: [
  #          {0, VOID}
  #        ]
  #      ]
  #  end
  #
  #  defmodule PathPaymentResultCode do
  #    use Enum,
  #      spec: [
  #        PATH_PAYMENT_SUCCESS: 0,
  #        PATH_PAYMENT_MALFORMED: -1,
  #        PATH_PAYMENT_UNDERFUNDED: -2,
  #        PATH_PAYMENT_SRC_NO_TRUST: -3,
  #        PATH_PAYMENT_SRC_NOT_AUTHORIZED: -4,
  #        PATH_PAYMENT_NO_DESTINATION: -5,
  #        PATH_PAYMENT_NO_TRUST: -6,
  #        PATH_PAYMENT_NOT_AUTHORIZED: -7,
  #        PATH_PAYMENT_LINE_FULL: -8,
  #        PATH_PAYMENT_NO_ISSUER: -9,
  #        PATH_PAYMENT_TOO_FEW_OFFERS: -10,
  #        PATH_PAYMENT_OFFER_CROSS_SELF: -11,
  #        PATH_PAYMENT_OVER_SENDMAX: -12
  #      ]
  #  end
  #
  #  defmodule SimplePaymentResult do
  #    use XDR.Type.Struct,
  #      spec: [
  #        destination: PublicKey,
  #        asset: Asset,
  #        amount: HyperInt
  #      ]
  #  end
  #
  #  defmodule PathPaymentResult do
  #    use Union,
  #      spec: [
  #        switch: PathPaymentResultCode,
  #        cases: [
  #          {0, PaymentSuccess},
  #          {-9, Asset}
  #        ]
  #      ]
  #
  #    defmodule PaymentSuccess do
  #      use XDR.Type.Struct,
  #        spec: [
  #          offers: ClaimOfferAtoms,
  #          last: SimplePaymentResult
  #        ]
  #
  #      defmodule ClaimOfferAtoms do
  #        use VariableArray, spec: [type: ClaimOfferAtom]
  #      end
  #    end
  #  end
end