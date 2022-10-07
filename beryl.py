#!/usr/bin/env python3
import re
from dataclasses import dataclass

# metacharacters
# . ^ $ * + ? { } [ ] \ | ( )


@dataclass
class Token:
    type: str
    value: str


class Tokenizer:
    def __init__(self, src_code=""):
        self.__TOKEN_TYPES = [
            ["def", r"\bdef\b"],
            ["end", r"\bend\b"],
            ["var", r"\b[a-zA-Z]\b"],
            ["int", r"\b[0-9]+\b"],
            ["lpa", r"("],
            ["rpa", r")"],
        ]
        self.__src_code = src_code

    def tokenize(self):
        # while self.__src_code != "":
        for token in self.__TOKEN_TYPES:
            # symbol = token[0]
            rgx = token[1]
            interpolated_regex = re.compile(rf"\A{rgx}")
            test_match = interpolated_regex.match(self.__src_code)
            if test_match:
                value = test_match.group()
                print("value: " + value)
                truncated = self.__src_code[len(value) :]
                print("truncated: " + truncated)
                # self.__src_code = truncated
                return


tokens = Tokenizer("def () 1 end")
print(tokens.__dict__["_Tokenizer__src_code"])
tokens.tokenize()
