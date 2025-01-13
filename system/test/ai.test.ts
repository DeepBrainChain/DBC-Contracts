import { expect } from "chai";
import { ethers, upgrades } from 'hardhat';
import { AI } from "../typechain";
import { AIStakingContractMock, DBCStakingContractMock } from "../typechain";

describe("AI Contract", function () {
    let ai: AI;
    let aiStakingContractMock: AIStakingContractMock;
    let dbcContractMock: DBCStakingContractMock;
    let owner: any;
    let addr1: any;
    let addr2: any;

    beforeEach(async function () {
        const AIFactory = await ethers.getContractFactory("AI");
        const AIStakingContractMockFactory = await ethers.getContractFactory("AIStakingContractMock");

        [owner, addr1, addr2] = await ethers.getSigners();

        aiStakingContractMock = await AIStakingContractMockFactory.deploy();
        await aiStakingContractMock.deployed();

        const DBCContractMockFactory = await ethers.getContractFactory("DBCStakingContractMock");

        [owner, addr1, addr2] = await ethers.getSigners();

        dbcContractMock = await DBCContractMockFactory.deploy();
        await dbcContractMock.deployed();

        try {
            ai = await upgrades.deployProxy(AIFactory, [dbcContractMock.address, [addr1.address, addr2.address]],{ initializer: 'initialize' });
        } catch (error) {
            console.log("AI contract already initialized.",await ai.dbcContract().address);
            if (error.message.includes("Initializable: contract is already initialized")) {
                console.log("AI contract already initialized.");
            } else {
                throw error;
            }
        }
    });

    describe("Initialization", function () {
        it("should initialize the contract and set the authorized reporters", async function () {
            const isAuthorized = await ai.authorizedReporters(addr1.address);
            expect(isAuthorized).to.be.true;

            const isNotAuthorized = await ai.authorizedReporters(addr2.address);
            expect(isNotAuthorized).to.be.true;

            const isNonExistent = await ai.authorizedReporters(owner.address);
            expect(isNonExistent).to.be.false;
        });
    });

    describe("Set Upgrade Permission", function () {
        it("should allow the owner to set upgrade permission", async function () {
            await ai.setUpgradePermission(addr1.address);
            const canUpgradeAddress = await ai.canUpgradeAddress();
            expect(canUpgradeAddress).to.equal(addr1.address);
        });

        it("should only allow the owner to set upgrade permission", async function () {
            await expect(ai.connect(addr1).setUpgradePermission(addr2.address))
                .to.be.revertedWith("Ownable: caller is not the owner");
        });
    });

    describe("Authorized Reporters", function () {
        it("should add and remove authorized reporters", async function () {
            await ai.removeAuthorizedReporter(addr1.address);
            let isAuthorized = await ai.authorizedReporters(addr1.address);
            expect(isAuthorized).to.be.false;
        });

        it("should not allow report staking contract whichi not registered", async function () {

            await expect(ai.connect(addr2).report(1, "Project1", 0, "Machine1"))
                .to.be.revertedWith("Staking contract not registered'");
        });
    });

    describe("Register Project Staking Contract", function () {
        it("should allow the registration of a project staking contract", async function () {
            const stakingContractAddress = aiStakingContractMock.address;

            await ai.registerProjectStakingContract("Project1", 0, stakingContractAddress);

            const registeredContract = await ai.projectName2StakingContractAddress("Project1", 0);
            expect(registeredContract).to.equal(stakingContractAddress);
        });

        it("should revert if project already registered", async function () {
            const stakingContractAddress = aiStakingContractMock.address;

            await ai.registerProjectStakingContract("Project1", 0, stakingContractAddress);

            await expect(
                ai.registerProjectStakingContract("Project1", 0, stakingContractAddress)
            ).to.be.revertedWith("Project already registered");
        });

        it("should not allow unauthorized reporters to report", async function () {

            await expect(ai.connect(addr2).report(1, "Project1", 0, "Machine1"))
                .to.be.revertedWith("Staking contract not registered'");
        });
    });

    describe("Report Machine State", function () {
        it("should correctly register a machine state", async function () {
            const stakingContractAddress = aiStakingContractMock.address;
            await ai.registerProjectStakingContract("Project1", 0, stakingContractAddress);

            await ai.connect(addr1).report(1, "Project1", 0, "Machine1"); // MachineRegister
            const machineState = await ai.getMachineState("Machine1", "Project1", 0);
            expect(machineState.isRegistered).to.be.true;

            await ai.connect(addr1).report(2, "Project1", 0, "Machine1"); // MachineRegister
            const machineState1 = await ai.getMachineState("Machine1", "Project1", 0);
            expect(machineState1.isRegistered).to.be.false;
        });

        it("should correctly update machine online status", async function () {
            const stakingContractAddress = aiStakingContractMock.address;
            await ai.registerProjectStakingContract("Project1", 0, stakingContractAddress);

            await ai.connect(addr2).report(3, "Project1", 0, "Machine1"); // MachineOnline
            const machineState = await ai.getMachineState("Machine1", "Project1", 0);
            expect(machineState.isOnline).to.be.true;

            await ai.connect(addr2).report(4, "Project1", 0, "Machine1"); // MachineOnline
            const machineState1 = await ai.getMachineState("Machine1", "Project1", 0);
            expect(machineState1.isOnline).to.be.false;
        });

        it("should emit events on machine state updates", async function () {
            const stakingContractAddress = aiStakingContractMock.address;
            await ai.registerProjectStakingContract("Project1", 0, stakingContractAddress);


            await expect(ai.connect(addr1).report(1, "Project1", 0, "Machine1"))
                .to.emit(ai, "MachineStateUpdate")
                .withArgs("Machine1", "Project1", 0, 1);

            await expect(ai.connect(addr2).report(2, "Project1", 0, "Machine1"))
                .to.emit(ai, "MachineStateUpdate")
                .withArgs("Machine1", "Project1", 0, 2);
        });
    });
});
