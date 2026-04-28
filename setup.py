from setuptools import setup, find_packages

setup(
    name="tao-apprentice",
    version="0.1.0",
    description="TAO Apprentice — Bittensor Subnet: Incentivized Miner Onboarding via Mentorship",
    author="Santideva",
    author_email="",
    url="https://github.com/YOUR_USERNAME/tao-apprentice",
    packages=find_packages(),
    python_requires=">=3.10",
    install_requires=[
        "bittensor>=7.0.0",
        "aiohttp>=3.9.0",
        "numpy>=1.26.0",
        "pandas>=2.1.0",
        "loguru>=0.7.2",
        "python-dotenv>=1.0.0",
        "pyyaml>=6.0.1",
        "py-substrate-interface>=1.7.0",
        "click>=8.1.7",
        "rich>=13.7.0",
    ],
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
)
