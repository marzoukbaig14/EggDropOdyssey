//
//  StoryScene.swift
//  EggDropOdyssey
//
//  Created by Eunice Adam on 11/16/23.
//

import SpriteKit

class StoryScene: SKScene {

    private var farmerNode: SKSpriteNode!
    private var speechBubbles: [SKSpriteNode] = []
    private var currentSpeechIndex = 0
    private var background : SKSpriteNode!
    private var farmerAnimation: SKAction!
    private var animatedFarmer: SKSpriteNode!
    private var goButton: SKSpriteNode!


    override func didMove(to view: SKView) {
        setupScene()
        presentDialogue()
    }

    func setupScene() {
        
        // Background setup
        background = SKSpriteNode(imageNamed: "farm")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = -1
        background.scale(to: self.size)
        self.addChild(background)
        
        // Farmer setup
        setupFarmerAnimation()
        
        // Speech bubble setup
        for i in 1...6 {
            let speechBubble = SKSpriteNode(imageNamed: "speech_bubble\(i)")
            speechBubble.position = CGPoint(x: frame.midX, y: frame.midY + 300)
            speechBubble.isHidden = true
            speechBubble.setScale(2.0)
            addChild(speechBubble)
            speechBubbles.append(speechBubble)
        }
    }
    
    func setupFarmerAnimation() {
        
        let farmerImages = [
            "farmer1", "farmer2"
        ]

        let farmerTextures = farmerImages.map { SKTexture(imageNamed: $0) }

        farmerAnimation = SKAction.animate(with: farmerTextures, timePerFrame: 0.25)

        animatedFarmer = SKSpriteNode(texture: farmerTextures.first)
        animatedFarmer.position = CGPoint(x: frame.midX - 80, y: frame.midY - 400)
        animatedFarmer.zPosition = 10
        animatedFarmer.setScale(2.0)
        animatedFarmer.run(SKAction.repeatForever(farmerAnimation))

        self.addChild(animatedFarmer)
    }
    
    func showGoButton() {
        goButton = SKSpriteNode(imageNamed: "go")
        goButton.position = CGPoint(x: frame.midX, y: frame.midY + 400)
        goButton.zPosition = 10
        addChild(goButton)
    }

    func presentDialogue() {
        // Next speech bubble
        speechBubbles[currentSpeechIndex].isHidden = false

        // Waiting, then moving to the next speech bubble
        let waitAction = SKAction.wait(forDuration: 2.5)
        let nextSpeechAction = SKAction.run {
            self.speechBubbles[self.currentSpeechIndex].isHidden = true
            self.currentSpeechIndex += 1
            if self.currentSpeechIndex < self.speechBubbles.count {
                self.presentDialogue()
            } else {
                // Dialogue finished, stop talking farmer
                self.animatedFarmer.removeAllActions()
                self.showGoButton()
            }
        }

        let sequence = SKAction.sequence([waitAction, nextSpeechAction])
        run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if touchedNode == goButton {
            
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: 1.0)
            
            self.view?.presentScene(gameScene, transition: transition)
            
            gameScene.startGame()
        }
        
    }
}

