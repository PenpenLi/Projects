local NumberChanger = class("NumberChanger")


function NumberChanger:ctor(startValue, endValue , setValueCallback, endCallback) 
    self._endCallback = endCallback
    self._setValueCallback = setValueCallback

    self._flashInterval = 1/30
    self._maxFlashCount = 10

    self._currentValue = startValue
    self._endValue = endValue

    self._isAsc = self._endValue > self._currentValue

    self._valueDelta = 0
    self._timer = nil
end


function NumberChanger:play()
    if self._endValue == self._currentValue then return end
    if self._timer ~= nil then return end

    --闪动数字直到目标self._value
    self._timer = GlobalFunc.addTimer(self._flashInterval, handler(self, self._refreshValue))

    self._valueDelta = (self._endValue - self._currentValue) / self._maxFlashCount
    if self._valueDelta > 0 then
        self._valueDelta = math.ceil(self._valueDelta)
    else
        self._valueDelta = -1 * math.ceil(-1*self._valueDelta)
    end
end

function NumberChanger:_refreshValue()
    --闪动数字直到目标self._value
    self._currentValue = self._currentValue + self._valueDelta

    local isEnded = false
    if self._isAsc == true then
        if self._currentValue >= self._endValue then
            self._currentValue = self._endValue
            isEnded = true
        end
    else
        if self._currentValue <= self._endValue then
            self._currentValue = self._endValue
            isEnded = true
        end
    end

    if self._setValueCallback ~= nil then
        self._setValueCallback(self._currentValue)
    end

    if isEnded == true then
        self:_end()
    end

end

function NumberChanger:stop()
    if self._timer then
        GlobalFunc.removeTimer(self._timer)
        self._timer = nil
    end
end

function NumberChanger:_end()
    if self._timer then
        GlobalFunc.removeTimer(self._timer)
        self._timer = nil
    end

    if self._endCallback ~= nil then
        self._endCallback()
        self._endCallback = nil
    end
end

return NumberChanger


