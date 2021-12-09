from math import sqrt
from typing import Dict
from loguru import logger

def getResult(swapA: list, swapB: list) -> Dict:
    X1 = swapA[0]
    Y1 = swapA[1]
    S1 = swapA[2]

    X2 = swapB[0]
    Y2 = swapB[1]
    S2 = swapB[2]

    M = 1 - S1
    N = 1 - S2

    flag1 = (M * N * X1 * Y2) - (X2 * Y1)
    flag2 = (M * N * X2 * Y1) - (X1 * Y2)

    if flag1 > 0:
        result = FunctionA(X1, Y1, X2, Y2, M, N)
        return result
    elif flag2 > 0:
        result = FunctionB(X1, Y1, X2, Y2, M, N)
        return result
    else:
        print("没有套利空间")

def FunctionA(X1, Y1, X2, Y2, M, N):
    resultDict1 = dict()
    W_max1 = ((sqrt(M * N * X1 * Y2) - sqrt(X2 * Y1)) ** 2) / (M * (X2 + (N * X1)))
    C_1 = (sqrt(M * N * X1 * X2 * Y1 * Y2) - (X2 * Y1)) / (M * (X2 + (N * X1)))
    price = BNBprice(tokenB_BNB)
    exchangeBNB = W_max1 * price
    #如果余额足够则直接返回最大盈利和需要投入的tokenB数量，以及最大盈利价值多少BNB

    if C_1<balance:
        resultDict1['spend_C1'] = C_1
        resultDict1['profit'] = W_max1
        resultDict1['BNBprice'] = price
        resultDict1["ExchangeBNB"] = exchangeBNB
        resultDict1["BalanceNotEnough"] = False
        logger.info(resultDict1)
        return resultDict1
    #如果余额不足，则计算投入钱包全部余额，盈利TokenB价值BNB数量
    else :
        BalanceNotEnough(X1, Y1, X2, Y2, M, N,balance,tokenB_BNB)

def FunctionB(X1, Y1, X2, Y2, M, N):
    resultDict2 = dict()
    W_max2 = ((sqrt(M * N * X2 * Y1) - sqrt(X1 * Y2)) ** 2) / (N * (X1 + (M * X2)))
    C_2 = (sqrt(M * N * X1 * X2 * Y1 * Y2) - (X1 * Y2)) / (N * (X1 + (M * X2)))
    price = BNBprice(tokenB_BNB)
    exchangeBNB = W_max2 * price

    #如果余额不足，则计算投入钱包全部余额，盈利TokenB价值BNB数量
    if C_2 < balance:
        resultDict2['spend_C2'] = C_2
        resultDict2['profit'] = W_max2
        resultDict2['BNBprice'] = price
        resultDict2["ExchangeBNB"] = exchangeBNB
        resultDict2["BalanceNotEnough"] = False
        logger.info(resultDict2)
        return resultDict2
    # 如果余额不足，则计算投入钱包全部余额，盈利TokenB价值BNB数量
    else :
        BalanceNotEnough(X1, Y1, X2, Y2, M, N,balance,tokenB_BNB)

    #当余额不足时，调用该函数进行校验,盈利价值多少BNB
def BalanceNotEnough(X1, Y1, X2, Y2, M, N,C,tokenB_BNB:list) -> Dict:
    resultDict = dict()
    flag1 = (M * N * X1 * Y2) - (X2 * Y1)
    flag2 = (M * N * X2 * Y1) - (X1 * Y2)
    #如果向SwapA支付TokenB,并向SwapB支付TokenA，最终利润价值多少BNB
    if flag1 > 0:
        incomeTokenA = (X1 - (X1 * Y1) / (Y1 + M * C))
        incomeTokenB = (Y2 - (X2 * Y2) / (X2+N * incomeTokenA))
        profit = incomeTokenB - C
        price = BNBprice(tokenB_BNB)
        exchangeBNB = profit * price
        resultDict["spend_C1"] = C
        # resultDict["incomeTokenB"] = incomeTokenB
        resultDict["profit"] = profit
        resultDict["BNBprice"] = price
        resultDict["ExchangeBNB"] = exchangeBNB
        resultDict["BalanceNotEnough"] = True
        logger.info(resultDict)
        return resultDict
    # 如果向SwapB支付TokenB,并向SwapA支付TokenA，最终利润价值多少BNB
    elif flag2>0:
        incomeTokenA = (X2 - (X2 * Y2) / (Y2 + N * C))
        incomeTokenB = (Y1 - (X1 * Y1) / (X1 + M * incomeTokenA))
        profit = incomeTokenB - C
        price = BNBprice(tokenB_BNB)
        exchangeBNB = profit * price
        resultDict["spend_C2"] = C
        # resultDict["incomeTokenB"] = incomeTokenB
        resultDict["profit"] = profit
        resultDict["BNBprice"] = price
        resultDict["ExchangeBNB"] = exchangeBNB
        resultDict["BalanceNotEnough"] = True
        logger.info(resultDict)
        return resultDict
    else:
        print("没有套利空间")
    #计算一个TokenB等于多少BNB
def BNBprice(tokenB_BNB):
    X1 = tokenB_BNB[0]
    Y1 = tokenB_BNB[1]
    m = tokenB_BNB[2]
    M = 1 - m
    _BNBprice = (X1 - (X1 * Y1) / (Y1 + M * 1))

    return _BNBprice

if __name__ == '__main__':
    v = 10 ** 18
    swapA = [6681887184904705738115761/v,29459984001450195474481/v, 0.003]
    swapB = [4082610681832653190591760329/v,17816876439998215933928822/v, 0.003]
    balance = 459747832792941686594/v
    tokenB_BNB = [1, 592, 0.003]
    getResult(swapA, swapB)

# if __name__ == '__main__':
#     swapA = [4000 , 10000 , 0.003]
#     swapB = [6999 , 10000 , 0.003]
#     tokenB_BNB = [1, 592, 0.003]
#     balance = 10000
#     getResult(swapA,swapB)



#返回spend_C1代表向swapA支付spend C1数量的tokenB,把获得的tokenA在SwapB卖出
#返回spend_C2代表向swapB支付spend C2数量的tokenB,把获得的tokenA在SwapA卖出
# spend_C对应的值就是投入TokenB数量
# exchangeBNB表示了本次交易最大盈利TokenB价值多少BNB

# 收到返回值后，直接判断exchangeBNB对应的值是否大于0.0025,
# 如果大于直接根据是spend_C1还是spend_C2,向SwapA或SwapB支付TokenB进行交易,不需要进行其他校验

#如果没有套利空间会返回"没有套利空间"
