def validate(string)
    !string.match(/\A[a-zA-Z0-9.\-_\s]*\z/).nil?
end

